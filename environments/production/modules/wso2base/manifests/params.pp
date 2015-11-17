#

class wso2base::params {

    $domain               = "example.com"
    $package_repo         = "http://downloads.${domain}"
    $depsync_svn_repo     = "http://svn.${domain}/svn/amdepsync"
    $local_package_dir    = "/mnt/packs"
    $hosts_mapping = [  
                        "192.168.57.237,puppetmaster puppet",
                        #"10.33.14.56,downloads.example.com",
                        #"192.168.19.37,mysql.example.com",
                        "192.168.57.233,qaamysql",
                        "192.168.19.33,keymanager",
                        "192.168.19.34,gateway",
                        "192.168.19.35,publisher",
                        "192.168.19.36,apistore",
			"192.168.57.234,pub.am.wso2.com",
			"192.168.57.234,store.am.wso2.com",
			"192.168.57.234,keymanager.am.wso2.com",
			"192.168.57.234,gateway.am.wso2.com",
			"192.168.57.234,mgt.gateway.am.wso2.com",
			"192.168.57.234,secure.servlet.gateway.am.wso2.com",
			"192.168.57.234,nio.gateway.am.wso2.com",
                        #"192.168.19.34,svn.example.com",
                        #"10.33.14.54,elb.example.com",
                        #"10.33.14.54,gateway.api.example.com",
                        #"10.33.14.54,mgt.gateway.api.example.com",
                        #"10.33.14.54,keymanager.api.example.com",
                        #"10.33.14.69,publisher.api.example.com",
                    ]

    # Java
    $java_home  = "jdk1.7.0_79"
    $package    = "jdk-7u79-linux-x64.gz"
    $java_dir   = '/opt'

    # users
    $owner = 'wso2user'
    $group = 'wso2user'

    # maven
    $maven_package  ="apache-maven-3.0.5-bin.tar.gz"
    $maven_dir      ="apache-maven-3.0.5" 

    # Service subdomains
    $am_subdomain         = 'api'
    $elb_subdomain        = 'elb'
    $gateway_subdomain    = 'gateway'
    $keymanager_subdomain = 'keymanager'
    $apistore_subdomain   = 'apistore'
    $publisher_subdomain  = 'publisher'
    $management_subdomain = 'mgt'
    
    $depsync_svn_user     = 'wso2'
    $depsync_svn_password = 'wso2123'
    
}
