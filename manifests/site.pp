import 'nginx'

stage { 'configure': require => Stage['main'] }
stage { 'deploy': require => Stage['configure'] }

node default {
	file { "/tmp/test.t":
		ensure => present,
	}
}

node base {
    class { wso2base:
	    stage => configure,
	}  
}

node 'puppetagent' {

    file { "/tmp/mcollective_test.t":
        ensure => present,
    }

}

node 'qaamysql' {
    
}

#publisher_node1
#publisher_node2

node 'qaa-puppet-apim-store-pub-1', 'qaa-puppet-apim-store-pub-2' inherits base {
    class { "apimanager::publisher":
        version            => "1.9.0",
        offset             => 0,
        depsync            => false,
        local_member_port  => '4000',
        clustering         => true,
        membershipScheme   => 'wka',
        cloud              => true,
        sub_cluster_domain => false,
        maintenance_mode   => 'zero',
        owner              => 'kurumba',
        group              => 'kurumba',
        members            => {'192.168.57.226' => '4000','192.168.57.228' => '4000','192.168.57.248' => '4000','192.168.57.247' => '4000'},
        port_mapping       => false,
        stage              => deploy,
    }
}

#store_node1
#store_node2

node 'qaa-puppet-store-1', 'qaa-puppet-store-2' inherits base {
    class { "apimanager::apistore":
        version            => "1.9.0",
        offset             => 0,
        depsync            => false,
        local_member_port  => '4000',
        clustering         => true,
        membershipScheme   => 'wka',
        cloud              => true,
        sub_cluster_domain => false,
        maintenance_mode   => 'zero',
        owner              => 'kurumba',
        group              => 'kurumba',
        members            => {'192.168.57.247' => '4000','192.168.57.248' => '4000','192.168.57.228' => '4000','192.168.57.226' => '4000'},
        port_mapping       => false,
        stage              => deploy,
    }
}

#KeyManager_node1
#KeyManager_node2

node 'qaa-puppet-apim-key-manager-1', 'qaa-puppet-apim-key-manager-2' inherits base {
    class { "apimanager::keymanager":
        version            => "1.9.0",
        offset             => 0,
        depsync            => false,
        local_member_port  => '4000',
        clustering         => true,
        membershipScheme   => 'wka',
        cloud              => false,
        sub_cluster_domain => false,
        maintenance_mode   => 'zero',
        owner              => 'kurumba',
        group              => 'kurumba',
        members            => {'192.168.57.227' => '4000','192.168.57.225' => '4000'},
        port_mapping       => false,
        stage              => deploy,
    }
}

#Gateway manager node1

node 'gatewayagent1' inherits base {
    class { "apimanager::gateway":
        version            => "1.9.0",
        offset             => 0,
        depsync            => true,
        local_member_port  => '4000',
        clustering         => true,
        membershipScheme   => 'wka',
        cloud              => true,
        sub_cluster_domain => 'mgt',
        maintenance_mode   => 'zero',
        owner              => 'kurumba',
        group              => 'kurumba',
        members            => {'192.168.57.231' => '4000'},
        port_mapping       => {"80" => "9763", "443" => "9443"},
        stage              => deploy,
        svn_url            => 'http://192.168.57.233/svn/testrepo/apim',
        svn_username       => 'user1',
        svn_password       => 'user1',
    }
}

#Gateway worker node2

node 'qaa-puppet-apim-gw-2' inherits base {
    class { "apimanager::gateway":
        version            => "1.9.0",
        offset             => 0,
        depsync            => true,
        local_member_port  => '4000',
        clustering         => true,
        membershipScheme   => 'wka',
        cloud              => true,
        sub_cluster_domain => 'worker',
        maintenance_mode   => 'zero',
        owner              => 'kurumba',
        group              => 'kurumba',
        members            => {'192.168.57.232' => '4000'},
        port_mapping       => {"80" => "9763", "443" => "9443"},
        stage              => deploy,
        svn_url            => 'http://192.168.57.233/svn/testrepo/apim',
        svn_username       => 'user1',
        svn_password       => 'user1',
    }
}

node 'qaa-puppet-nginx' {
	
	include 'nginx'
	
	$dirpath = '/etc/nginx/ssl'
	
	exec { "create_ssl_cert_dir":
		path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
                command => "mkdir -p ${dirpath}",
        }

	file { "/etc/nginx/ssl":
    		source => "puppet:///modules/nginx/ssl",
		recurse => true,
	}

	file { 
		"/etc/nginx/conf.d/publisher.conf": source => "puppet:///modules/nginx/conf.d/publisher.conf";
		"/etc/nginx/conf.d/apistore.conf": source => "puppet:///modules/nginx/conf.d/apistore.conf";
		"/etc/nginx/conf.d/gateway.conf": source => "puppet:///modules/nginx/conf.d/gateway.conf";
		"/etc/nginx/conf.d/keymanager.conf": source => "puppet:///modules/nginx/conf.d/keymanager.conf";
	}

}

# TODO
# 1. merge component instances into one definition
# 2. puppetize a given certificate import to pack keystores
# 3. puppetize mysql
# 4. generalize nginx module
# 5. dynamically add ssl certs to keystores of the daily build packs
# 6. add a cluster health check script or tool, shell script maybe
