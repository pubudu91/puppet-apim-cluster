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
        $members      = {'publisher' => '4000', 'apistore' => '4000'}
        $myname = 'test_axis2.xml'

        file {  "/tmp/$myname":
                ensure  => file,
                content => template('apimanager/1.9.0/conf/axis2/axis2.xml.erb'),
        }
}

node 'suhan-mysql-server.openstacklocal' {
	
}

node 'suhan-apistore' inherits base {
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
        members            => {'publisher' => '4000'},
        port_mapping       => false,
        stage              => deploy,
    }
}

node 'suhan-publisher' inherits base {
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
        members            => {'apistore' => '4000'},
        port_mapping       => false,
        stage              => deploy,
    }
}

node 'suhan-gateway' inherits base {
   ## Gateway MGT
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

node 'suhan-keymanager' inherits base {
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
        members            => false,
        port_mapping       => {"8280" => "9763", "8243" => "9443"},
        stage              => deploy,
    }
}

node 'nginx.openstacklocal' {
	
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

	file { "/etc/nginx/conf.d/wso2carbon.conf":
		source => "puppet:///modules/nginx/wso2carbon.conf",
	}

}
