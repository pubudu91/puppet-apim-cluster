#
# Default node definition
# This will be the first puppet run on all nodes.
# During this run, based on the agent request IP address, a certname will be 
# selected from hieradata and written to agent's /etc/puppet/puppet.conf file
#
node default {

        # Initializing deployment
        notify {"Configuring deployment, running the default configuration, writing certnames.....": }

        # Writing certnames to prepare the puppet agent nodes
        file {  "/etc/puppet/puppet.conf":
                ensure  => file,
                content => template('wso2base/puppet.agent.conf.erb'),
        }

}

