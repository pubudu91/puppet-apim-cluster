include '::mysql::server'

class cleandb::mysql($apim_version, $user, $password, $host, $apimgt_db_sql, $user_db_sql, $reg_db_sql)
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
    sql 	=> $apimgt_db_sql,
 }

mysql::db { 'userdb':
    user  	=> $user,
    password 	=> $password,
    host     	=> $host,
    sql 	=> $user_db_sql,
 }

mysql::db { 'regdb':
    user  	=> $user,
    password 	=> $password,
    host     	=> $host,
    sql 	=> $reg_db_sql,
 }

}
