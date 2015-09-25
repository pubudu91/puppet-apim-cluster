#
class wso2base::java (
    $java_home 	= $wso2base::params::java_home,
    $package    = $wso2base::params::package,
    $java_dir   = $wso2base::params::java_dir,
    )  inherits wso2base::params {

    file { "/opt":
                source => "puppet:///modules/wso2base/",
                recurse => true,
                ignore => "FilesToCopyHere.txt",
        }
    
    file { "/opt/java":
        ensure 	=> link,
        target	=> "/opt/${java_home}",
        require	=> Exec["install_java"],
    }
    
    exec { 

        #"downloading_java":
        #path      => ["/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"],
        #cwd       => $java_dir,
        #unless    => "test -f ${java_dir}/${package}",
        #command   => "wget -q ${package_repo}/${package}";

        "install_java":
        path      => ["/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"],
        cwd	  => "/opt",
        command   => "tar -xzf ${java_dir}/${package}",
        unless    => "test -d /opt/${java_home}",
        creates   => "/opt/${java_home}/COPYRIGHT";

        #creates   => "/opt/${java_home}/COPYRIGHT",
        #require   => Exec["downloading_java"];

        "changing_permissions":
        path      => ["/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"],
        cwd	  => "/opt",
        command   => "chown -R root:root ${java_dir}/${java_home}; chmod -R 755 ${java_dir}/${java_home}",
        require   => Exec["install_java"];
    } 

}
 
