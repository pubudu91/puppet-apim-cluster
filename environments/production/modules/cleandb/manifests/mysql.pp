include '::mysql::server'

class cleandb::mysql($apim_version, $user, $password, $host)
{

staging::deploy { "wso2am-${apim_version}.zip":
  source        => "puppet:///files/packs/apimanager/${apim_version}/wso2am-${apim_version}.zip",
  target        => '/tmp/',
}

exec { "delete-db":
  command 	=> "/usr/bin/mysql -u$user -p$password  -e \"DROP DATABASE apimgtdb;DROP DATABASE regdb;DROP DATABASE userdb;\"",
}

mysql::db { 'apimgtdb':
    charset	=> 'latin1',
    collate	=> 'latin1_swedish_ci',
    user	=> $user,
    password 	=> $password,
    host     	=> $host,
    sql 	=> "/tmp/wso2am-${apim_version}/dbscripts/apimgt/mysql.sql",
 }

mysql::db { 'userdb':
    user  	=> $user,
    password 	=> $password,
    host     	=> $host,
    sql 	=> "/tmp/wso2am-${apim_version}/dbscripts/mysql.sql",
 }

mysql::db { 'regdb':
    user  	=> $user,
    password 	=> $password,
    host     	=> $host,
    sql 	=> "/tmp/wso2am-${apim_version}/dbscripts/mysql.sql",
 }

}
