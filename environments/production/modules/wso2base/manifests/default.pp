import 'nginx'

# deployment triggering will be done by either puppet or jenkins
# allowed values
# 'puppet'
# 'jenkins'
$deployment_trig_member = 'jenkins'

$common     = hiera("nodeinfo")
$datasource = hiera("datasources")

stage { 'configure': require => Stage['main'] }
stage { 'deploy': require => Stage['configure'] }

node default {

        # Initializing deployment
        notify {"Configuring deployment, running the default configuration, writing certnames.....": }

        # This block will be executed only if we are triggering the deployment from puppet master
        # If the Jenkins is controlling the cluster deployment through mCollective, then the deployment_pattern
        # factor variable should be exported/pushed to all agent nodes by Jenkins using mCollective or other means
        # > export FACTER_deployment_pattern=`pattern2`
        if $deployment_trig_member == 'puppet' {
                        exec { "creating_facter_dep_pattern":
                        path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
                        command => "rm /etc/facter/facts.d/deployment_pattern.txt;mkdir -p /etc/facter/facts.d;echo \"deployment_pattern=`${deployment_pattern}`\" >> /etc/facter/facts.d/deployment_pattern.txt",
                }
        }

        # Writing certnames to prepare the puppet agent nodes
        file {  "/etc/puppet/puppet.conf":
                ensure  => file,
                content => template('wso2base/puppet.agent.conf.erb'),
        }

}

# This is the base node required by all WSO2 product puppet modules
# HOW TO INCLUDE
# e.g.: node /publisher/ inherits base {
node base {
    class { wso2base:
            stage => configure,
        }
}

