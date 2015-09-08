include '::mysql::server'

class cleandb::mysql($rootUser,$rootPassword,$user,$password,$host,$apimgtdb,$userdb,$regdb) 
{

staging::deploy { 'wso2am-1.9.0.zip':
  source => 'puppet:///files/packs/wso2am-1.9.0.zip',
  target => '/tmp/',
}

exec { "delete-db":
  command => "/usr/bin/mysql -u$rootUser -p$rootPassword -e \"DROP DATABASE apimgtdb;DROP DATABASE regdb;DROP DATABASE userdb;\"",
}

mysql::db { 'apimgtdb':
    charset        => 'latin1',
    collate        => 'latin1_swedish_ci',
    user  => $user,
    password => $password,
    host     => $host,
    sql => $apimgtdb,
 }

mysql::db { 'userdb':
    user  => $user,
    password => $password,
    host     => $host,
    sql => $userdb,
 }

mysql::db { 'regdb':
    user  => $user,
    password => $password,
    host     => $host,
    sql => $regdb,
 }
}
