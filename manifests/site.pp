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
        $local_member_port = 4000
        $clustering = true
        #$members      = {'publisher' => '4001', 'apistore' => '4001',}
        $members = undef
        $myname = 'test_axis2.xml'

        file {  "/tmp/$myname":
                ensure  => file,
                content => template('apimanager/1.9.0/conf/axis2/axis2.xml.erb'),
        }
}

node 'suhan-mysql-server.openstacklocal' {
	
}

#publisher_node1

node 'qaa-puppet-apim-store-pub-1' inherits base {
    class { "apimanager::publisher":
        version            => "1.9.0",
        offset             => 0,
        depsync            => false,
        local_member_port  => '4000',
        clustering         => true,
        cloud              => true,
        sub_cluster_domain => false,
        maintenance_mode   => 'refresh',
        owner              => 'kurumba',
        group              => 'kurumba',
        members            => {'192.168.57.226' => '4000','192.168.57.248' => '4000','192.168.57.247' => '4000'},
        port_mapping       => false,
        stage              => deploy,
    }
}

#publisher_node2

node 'qaa-puppet-apim-store-pub-2' inherits base {
    class { "apimanager::publisher":
        version            => "1.9.0",
        offset             => 0,
        depsync            => false,
        local_member_port  => '4000',
        clustering         => true,
        cloud              => true,
        sub_cluster_domain => false,
        maintenance_mode   => 'refresh',
        owner              => 'kurumba',
        group              => 'kurumba',
        members            => {'192.168.57.228' => '4000','192.168.57.248' => '4000','192.168.57.247' => '4000'},
        port_mapping       => false,
        stage              => deploy,
    }
}


#store_node1

node 'qaa-puppet-store-1' inherits base {
    class { "apimanager::apistore":
        version            => "1.9.0",
        offset             => 0,
        depsync            => false,
        local_member_port  => '4000',
        clustering         => true,
        cloud              => true,
        sub_cluster_domain => false,
        maintenance_mode   => 'refresh',
        owner              => 'kurumba',
        group              => 'kurumba',
        members            => {'192.168.57.248' => '4000','192.168.57.228' => '4000','192.168.57.226' => '4000'},
        port_mapping       => false,
        stage              => deploy,
    }
}

#store_node2

node 'qaa-puppet-store-2' inherits base {
    class { "apimanager::apistore":
        version            => "1.9.0",
        offset             => 0,
        depsync            => false,
        local_member_port  => '4000',
        clustering         => true,
        cloud              => true,
        sub_cluster_domain => false,
        maintenance_mode   => 'refresh',
        owner              => 'kurumba',
        group              => 'kurumba',
        members            => {'192.168.57.247' => '4000','192.168.57.228' => '4000','192.168.57.226' => '4000'},
        port_mapping       => false,
        stage              => deploy,
    }
}

#KeyManager_node1

node 'qaa-puppet-apim-key-manager-1' inherits base {
    class { "apimanager::keymanager":
        version            => "1.9.0",
        offset             => 0,
        depsync            => false,
        local_member_port  => '4000',
        clustering         => true,
        cloud              => false,
        sub_cluster_domain => false,
        maintenance_mode   => 'refresh',
        owner              => 'kurumba',
        group              => 'kurumba',
        members            => {'192.168.57.225' => '4000'},
        port_mapping       => {"8280" => "9763", "8243" => "9443"},
        stage              => deploy,
    }
}

#KeyManager_node2

node 'qaa-puppet-apim-key-manager-2' inherits base {
    class { "apimanager::keymanager":
        version            => "1.9.0",
        offset             => 0,
        depsync            => false,
        local_member_port  => '4000',
        clustering         => true,
        cloud              => false,
        sub_cluster_domain => false,
        maintenance_mode   => 'refresh',
        owner              => 'kurumba',
        group              => 'kurumba',
        members            => {'192.168.57.227' => '4000'},
        port_mapping       => {"8280" => "9763", "8243" => "9443"},
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
        cloud              => true,
        sub_cluster_domain => 'mgt',
        maintenance_mode   => 'refresh',
        owner              => 'kurumba',
        group              => 'kurumba',
        members            => false,
        port_mapping       => {"8280" => "9763", "8243" => "9443"},
        stage              => deploy,
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

	file { "/etc/nginx/conf.d/publisher.conf":
		source => "puppet:///modules/nginx/conf.d/publisher.conf",
	}

        host { 'pub.wso2.am.com':
 	   ip => '192.168.57.239',
	}
}
