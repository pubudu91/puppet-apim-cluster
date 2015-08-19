#
class wso2base::environment (
    ) inherits wso2base::params {

    file { "/etc/environment":
        owner   => root,
        group   => root,
        mode    => 775,
        content => template("wso2base/environment.erb"),
    }
    ->
    exec { "source_file":
        path      => ["/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"],
        command   => "bash -c 'source /etc/environment'";
        
    }
}
