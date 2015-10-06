# this module is still under development
class nginx_plus inherits ::nginx_plus::params {

	$nginx_key_dirpath = '/etc/ssl/nginx'
	$nginx_apt_dirpath = '/etc/apt/apt.conf.d'
	$packages = ["apt-transport-https", "libgnutls26", "libcurl3-gnutls"]

        exec { "create_ssl_cert_dir_nginx_plus":
                path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
                command => "mkdir -p ${nginx_key_dirpath}",
        }
        ->
        file { "$nginx_key_dirpath":
                source => "puppet:///modules/nginx_plus/keys",
                owner  => root,
    		group  => root,
		recurse => true,
        }
	->
	exec { "adding_nginx_signing_key":
                path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
                command => 'wget http://nginx.org/keys/nginx_signing.key && sudo apt-key add nginx_signing.key',
        }
	->
    	package { $packages:
        	ensure  => installed,
    	}
	->
	exec { "adding_nginx_plus_to_sources_list":
                path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
                command => "printf \"deb https://plus-pkgs.nginx.com/ubuntu `lsb_release -cs` nginx-plus\n\" >/etc/apt/sources.list.d/nginx-plus.list",
        }
	->
	file { "$nginx_apt_dirpath":
                source => "puppet:///modules/nginx_plus/apt",
                owner  => root,
    		group  => root,
		recurse => true,
        }
	->
	exec { "update_repo_information":
                path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
                command => 'apt-get update',
        }
	->
	exec { "install_nginx_plus_package":
                path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
                command => 'apt-get install nginx-plus',
        }
}
