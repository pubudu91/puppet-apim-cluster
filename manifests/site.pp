import 'nginx'

stage { 'configure': require => Stage['main'] }
stage { 'deploy': require => Stage['configure'] }

node default {
 
	#inherits base
  	#include wso2base::node_selector

  	# for debug output on the puppet client - with full source information
	notify {"Node definition mismatch, applying default configuration...":
    		withpath => true,
	}
}

node base {
    class { wso2base:
	    stage => configure,
	}  
}

node 'puppetagent' {

    #include wso2base::nginx
    file {  "/tmp/mainenv.txt":
                ensure  => file,
                content => "this is main env",
        }
}

# mysql db

node 'qaamysql' {
$mysql = hiera("mysql")
      class { "cleandb::mysql":
          rootUser => $mysql[rootUser],
          rootPassword => $mysql[rootPassword],
          user => $mysql[user],
          password => $mysql[password],
          host => $mysql[host],
          apimgtdb => $mysql[apimgtdb],
	  userdb => $mysql[userdb],
          regdb => $mysql[regdb],
  }	
}

node /publisher/ inherits base {
    $publisher = hiera("publisher")
      class { "apimanager::publisher":
        version            => $publisher[version],
        offset             => $publisher[offset],
        depsync            => $publisher[depsync],
        local_member_port  => $publisher[local_member_port],
        clustering         => $publisher[clustering],
        membershipScheme   => $publisher[membershipScheme],
        cloud              => $publisher[cloud],
        sub_cluster_domain => $publisher[sub_cluster_domain],
        maintenance_mode   => $publisher[maintenance_mode],
        owner              => $publisher[owner],
        group              => $publisher[group],
        members            => $publisher[members],
        port_mapping       => $publisher[port_mapping],
        stage              => $publisher[stage],
    }
}


node /store/ inherits base {
  $store = hiera("store")
      class { "apimanager::apistore":
        version            => $store[version],
        offset             => $store[offset],
        depsync            => $store[depsync],
        local_member_port  => $store[local_member_port],
        clustering         => $store[clustering],
        membershipScheme   => $store[membershipScheme],
        cloud              => $store[cloud],
        sub_cluster_domain => $store[sub_cluster_domain],
        maintenance_mode   => $store[maintenance_mode],
        owner              => $store[owner],
        group              => $store[group],
        members            => $store[members],
        port_mapping       => $store[port_mapping],
        stage              => $store[stage],
    }
}


node /keymanager/ inherits base {
    $keymanager = hiera("keymanager")
      class { "apimanager::keymanager":
        version            => $keymanager[version],
        offset             => $keymanager[offset],
        depsync            => $keymanager[depsync],
        local_member_port  => $keymanager[local_member_port],
        clustering         => $keymanager[clustering],
        membershipScheme   => $keymanager[membershipScheme],
        cloud              => $keymanager[cloud],
        sub_cluster_domain => $keymanager[sub_cluster_domain],
        maintenance_mode   => $keymanager[maintenance_mode],
        owner              => $keymanager[owner],
        group              => $keymanager[group],
        members            => $keymanager[members],
        port_mapping       => $keymanager[port_mapping],
        stage              => $keymanager[stage],
    }
}


node /gateway/ inherits base {
 $gateway = hiera("gateway")
      class { "apimanager::gateway":
        version            => $gateway[version],
        offset             => $gateway[offset],
        depsync_enabled    => $gateway[depsync_enabled],
        local_member_port  => $gateway[local_member_port],
        clustering         => $gateway[clustering],
        membershipScheme   => $gateway[membershipScheme],
        cloud              => $gateway[cloud],
        sub_cluster_domain => $gateway[sub_cluster_domain],
        maintenance_mode   => $gateway[maintenance_mode],
        owner              => $gateway[owner],
        group              => $gateway[group],
        members            => $gateway[members],
        port_mapping       => $gateway[port_mapping],
        stage              => $gateway[stage],
        svn_url            => $gateway[svn_url],
        svn_username       => $gateway[svn_username],
        svn_password       => $gateway[svn_password]
    }
}

node /loadbalancer/ {
	
	include 'nginx'
	
	$dirpath = '/etc/nginx/ssl'

	exec { "create_ssl_cert_dir":
		path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
                command => "mkdir -p ${dirpath}",
        }

	file { "$dirpath":
    		source => "puppet:///modules/nginx/ssl",
		recurse => true,
	}

        file { "/etc/nginx/conf.d/apimanger.conf":
            owner   => root,
            group   => root,
            mode    => 775,
            content => template("wso2base/nginx.erb"),
        }

}

# TODO
# 1. merge component instances into one definition
# 2. puppetize a given certificate import to pack keystores
# 3. puppetize mysql
# 4. generalize nginx module
# 5. dynamically add ssl certs to keystores of the daily build packs
# 6. add a cluster health check script or tool, shell script maybe
