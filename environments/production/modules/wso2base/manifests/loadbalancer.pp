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

node /nginxplus/ {

        include 'nginx_plus'

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
            #notify  => Service["nginx"],  # this sets up the relationship
            owner   => root,
            group   => root,
            mode    => 775,
            content => template("wso2base/nginx.erb"),
        }
	-> 
	exec { "restart_nginx":
                path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
                command => "service nginx restart",
        }

}
