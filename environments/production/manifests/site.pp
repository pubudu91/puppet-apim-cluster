import 'nginx'

# deployment triggering will be done by either puppet or jenkins
# allowed values
# 'puppet'
# 'jenkins'
$deployment_trig_member = 'jenkins'

# Clustering deployment pattern
# ENABLE this variable ONLY IF deployment_trig_member is 'puppet'
# allowed values
# 'pattern1'
# 'pattern2'
#$deployment_pattern = 'pattern3'

$common     = hiera("nodeinfo")
$datasource = hiera("datasources")

stage { 'configure': require => Stage['main'] }
stage { 'deploy': require => Stage['configure'] }

# WHEN WILL BE EXECUTED,
# 1. After initial cluster configuration when the puppet is running on agents for the first time
# 2. After each clustering pattern deployment cleanup
#
# TASKS PERFORMED
# 1. Export factor variable deployment_pattern to all agent nodes ONLY IF PUPPET MASTER IS controlling the cluster
# 2. Inject certname parameter to puppet agents' /etc/puppet/puppet.conf configuration file
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

# mysql db
# This will ONLY cleanup the databases apimgtdb, userdb, regdb in mysql node
# This has to be triggered after each test execution
node 'database' {
        $datasource = hiera("datasources")
	$datasourcesql = hiera("datasourcesql")
      	class { "cleandb::mysql":
          apim_version  => $common[version],
          user 		=> $datasource[db_root_user],
          password 	=> $datasource[db_root_user_password],
          host 		=> $datasource[host],
          apimgt_db_sql	=> $datasourcesql[apimgt_db_sql],
	  user_db_sql	=> $datasourcesql[user_db_sql],
          reg_db_sql	=> $datasourcesql[reg_db_sql],
  }	
}

node 'migrationtest'{

$mysql = hiera("mysql")
      class { "migration::apimgt18to19":
          rootUser => $mysql[rootUser],
          rootPassword => $mysql[rootPassword],
          user => $mysql[user],
          password => $mysql[password],
          host => $mysql[host],
          apimgtdb => $mysql[apimgtdb],
          userdb => $mysql[userdb],
          regdb => $mysql[regdb],
  }

notify {"Running with >>>>>>>>>>>>>>>>>":}
}

node /publisher/ inherits base {
    $publisher = hiera("publisher")
      class { "apimanager::publisher":
        version            		=> $common[version],
        offset             		=> $common[offset],
        depsync            		=> $publisher[depsync],
        local_member_port  		=> $publisher[local_member_port],
        clustering         		=> $publisher[clustering],
        membershipScheme   		=> $publisher[membershipScheme],
        cloud              		=> $publisher[cloud],
        cluster_domain     		=> $publisher[cluster_domain],
        sub_cluster_domain 		=> $publisher[sub_cluster_domain],
        maintenance_mode   		=> $common[maintenance_mode],
        owner              		=> $common[owner],
        group              		=> $common[group],
        members            		=> $publisher[members],
        port_mapping       		=> $publisher[port_mapping],
        stage              		=> $publisher[stage],
        registry_db_connection_url	=> $datasource[registry_db_connection_url],
        registry_db_user		=> $datasource[registry_db_user],
        registry_db_password		=> $datasource[registry_db_password],
	registry_db_driver_name		=> $datasource[registry_db_driver_name],
        userstore_db_connection_url	=> $datasource[userstore_db_connection_url],
        userstore_db_user		=> $datasource[userstore_db_user],
	userstore_db_password		=> $datasource[userstore_db_password],
	userstore_db_driver_name	=> $datasource[userstore_db_driver_name],
	apim_db_connection_url		=> $datasource[apim_db_connection_url],
	apim_db_user			=> $datasource[apim_db_user],
	apim_db_password 		=> $datasource[apim_db_password],
  	apim_db_driver_name		=> $datasource[apim_db_driver_name],	 
    }
}

node /pubstore/ inherits base {
 $pubstore = hiera("pubstore")
      class { "apimanager::pubstore":
        version                         => $common[version],
        offset                          => $common[offset],
        local_member_port               => $pubstore[local_member_port],
        clustering                      => $pubstore[clustering],
        membershipScheme                => $pubstore[membershipScheme],
        cloud                           => $pubstore[cloud],
        sub_cluster_domain              => $pubstore[sub_cluster_domain],
        maintenance_mode                => $common[maintenance_mode],
        owner                           => $common[owner],
        group                           => $common[group],
        members                         => $pubstore[members],
        port_mapping                    => $pubstore[port_mapping],
        stage                           => $pubstore[stage],
        registry_db_connection_url      => $datasource[registry_db_connection_url],
        registry_db_user                => $datasource[registry_db_user],
        registry_db_password            => $datasource[registry_db_password],
        registry_db_driver_name         => $datasource[registry_db_driver_name],
        userstore_db_connection_url     => $datasource[userstore_db_connection_url],
        userstore_db_user               => $datasource[userstore_db_user],
        userstore_db_password           => $datasource[userstore_db_password],
        userstore_db_driver_name        => $datasource[userstore_db_driver_name],
        apim_db_connection_url          => $datasource[apim_db_connection_url],
        apim_db_user                    => $datasource[apim_db_user],
        apim_db_password                => $datasource[apim_db_password],
        apim_db_driver_name             => $datasource[apim_db_driver_name],
    }
}

node /store/ inherits base {
  $store = hiera("store")
      class { "apimanager::apistore":
        version            		=> $common[version],
        offset             		=> $common[offset],
        depsync            		=> $store[depsync],
        local_member_port  		=> $store[local_member_port],
        clustering         		=> $store[clustering],
        membershipScheme   		=> $store[membershipScheme],
        cloud              		=> $store[cloud],
        cluster_domain     		=> $store[cluster_domain],
        sub_cluster_domain 		=> $store[sub_cluster_domain],
        maintenance_mode   		=> $common[maintenance_mode],
        owner              		=> $common[owner],
        group              		=> $common[group],
        members            		=> $store[members],
        port_mapping       		=> $store[port_mapping],
        stage              		=> $store[stage],
        registry_db_connection_url      => $datasource[registry_db_connection_url],
        registry_db_user                => $datasource[registry_db_user],
        registry_db_password            => $datasource[registry_db_password],
        registry_db_driver_name         => $datasource[registry_db_driver_name],
        userstore_db_connection_url     => $datasource[userstore_db_connection_url],
        userstore_db_user               => $datasource[userstore_db_user],
        userstore_db_password           => $datasource[userstore_db_password],
        userstore_db_driver_name        => $datasource[userstore_db_driver_name],
        apim_db_connection_url          => $datasource[apim_db_connection_url],
        apim_db_user                    => $datasource[apim_db_user],
        apim_db_password                => $datasource[apim_db_password],
        apim_db_driver_name             => $datasource[apim_db_driver_name],
    }
}


node /keymanager/ inherits base {
    $keymanager = hiera("keymanager")
      class { "apimanager::keymanager":
        version            		=> $common[version],
        offset             		=> $common[offset],
        depsync            		=> $keymanager[depsync],
        local_member_port  		=> $keymanager[local_member_port],
        clustering         		=> $keymanager[clustering],
        membershipScheme   		=> $keymanager[membershipScheme],
        cloud              		=> $keymanager[cloud],
        sub_cluster_domain 		=> $keymanager[sub_cluster_domain],
        maintenance_mode   		=> $common[maintenance_mode],
        owner              		=> $common[owner],
        group              		=> $common[group],
        members            		=> $keymanager[members],
        port_mapping       		=> $keymanager[port_mapping],
        stage              		=> $keymanager[stage],
        registry_db_connection_url      => $datasource[registry_db_connection_url],
        registry_db_user                => $datasource[registry_db_user],
        registry_db_password            => $datasource[registry_db_password],
        registry_db_driver_name         => $datasource[registry_db_driver_name],
        userstore_db_connection_url     => $datasource[userstore_db_connection_url],
        userstore_db_user               => $datasource[userstore_db_user],
        userstore_db_password           => $datasource[userstore_db_password],
        userstore_db_driver_name        => $datasource[userstore_db_driver_name],
        apim_db_connection_url          => $datasource[apim_db_connection_url],
        apim_db_user                    => $datasource[apim_db_user],
        apim_db_password                => $datasource[apim_db_password],
        apim_db_driver_name             => $datasource[apim_db_driver_name],
    }
}


node /gateway/ inherits base {
 $gateway = hiera("gateway")
      class { "apimanager::gateway":
        version            		=> $common[version],
        offset             		=> $common[offset],
        depsync_enabled    		=> $gateway[depsync_enabled],
        local_member_port  		=> $gateway[local_member_port],
        clustering         		=> $gateway[clustering],
        membershipScheme   		=> $gateway[membershipScheme],
        cloud              		=> $gateway[cloud],
        sub_cluster_domain 		=> $gateway[sub_cluster_domain],
        maintenance_mode   		=> $common[maintenance_mode],
        owner              		=> $common[owner],
        group              		=> $common[group],
        members            		=> $gateway[members],
        port_mapping       		=> $gateway[port_mapping],
        stage              		=> $gateway[stage],
        svn_url            		=> $common[svn_url],
        svn_username       		=> $common[svn_username],
        svn_password       		=> $common[svn_password],
        registry_db_connection_url      => $datasource[registry_db_connection_url],
        registry_db_user                => $datasource[registry_db_user],
        registry_db_password            => $datasource[registry_db_password],
        registry_db_driver_name         => $datasource[registry_db_driver_name],
        userstore_db_connection_url     => $datasource[userstore_db_connection_url],
        userstore_db_user               => $datasource[userstore_db_user],
        userstore_db_password           => $datasource[userstore_db_password],
        userstore_db_driver_name        => $datasource[userstore_db_driver_name],
        apim_db_connection_url          => $datasource[apim_db_connection_url],
        apim_db_user                    => $datasource[apim_db_user],
        apim_db_password                => $datasource[apim_db_password],
        apim_db_driver_name             => $datasource[apim_db_driver_name],
    }
}

node /loadbalancer/ {
	
	include 'nginx'
	
	$dirpath = '/etc/nginx/ssl'

	exec { "create_ssl_cert_dir":
		path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
                command => "mkdir -p ${dirpath}",
        }
	->
	file { "$dirpath":
    		source => "puppet:///modules/nginx/ssl",
		recurse => true,
	}
	->
        file { "/etc/nginx/conf.d/apimanger.conf":
	    notify  => Service["nginx"],  # this sets up the relationship
	    owner   => root,
            group   => root,
            mode    => 775,
            content => template("wso2base/nginx.erb"),
        }

}

node /tomcatserver/ {
	staging::deploy { 'apache-tomcat-6.0.44.zip':
	    source => 'puppet:///files/apache-tomcat-6.0.44.zip',
	    target => '/opt/',
	}
}

node /jenkins/ {
    class { wso2base::hosts:} 
}


# To test your puppet code use this block
node 'puppetagent' {
	notify {"Applying puppet agent configuration...":}
	$common = hiera("nodeinfo")
	file {  "/tmp/hi.txt":
                ensure  => file,
                content => $common[version],
        }
}

# TODO
# 1. move common vars like version, to a common.yaml file
# 2. templates for 1.9.1 and 1.10.0
# 3. take out db username and get from database.yaml file
