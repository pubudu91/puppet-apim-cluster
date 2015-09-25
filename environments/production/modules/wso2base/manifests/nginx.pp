class wso2base::nginx {
     
 file { "/tmp/sample.conf":
        owner   => root,
        group   => root,
        mode    => 775,
        content => template("wso2base/nginx.erb"),
    }
}

