#myql db
# This will ONLY cleanup the databases apimgtdb, userdb, regdb in mysql node
# This has to be triggered after each test execution
node 'database' {
        $datasource = hiera("datasources")
        class { "cleandb::mysql":
          apim_version  => $common[version],
          user          => $datasource[db_root_user],
          password      => $datasource[db_root_user_password],
          host          => $datasource[host],
  }
}

node 'migrationtest'{

$mysql = hiera("mysql")
      class { "migration::apimgt18to19":
          rootUser => $mysql[rootUser],
          rootPassword => $mysql[rootPassword],
          user => $mysql[user],
          password => $mysql[password],
          host => $mysql[host],
          apimgtdb => $mysql[apimgtdb],
          userdb => $mysql[userdb],
          regdb => $mysql[regdb],
  }

notify {"Running with >>>>>>>>>>>>>>>>>":}
}

node /tomcatserver/ {
        staging::deploy { 'apache-tomcat-6.0.44.zip':
            source => 'puppet:///files/apache-tomcat-6.0.44.zip',
            target => '/opt/',
        }
}

node /jenkins/ {
    class { wso2base::hosts:}
}

