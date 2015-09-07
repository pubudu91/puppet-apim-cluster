class cleandb inherits cleandb::params{

class { '::mysql::server':}

exec { "delete-db":
  command => "/usr/bin/mysql -uroot -proot -e \"DROP DATABASE apimgtdb;DROP DATABASE regdb;DROP DATABASE userdb;\"",
}

mysql::db { 'apimgtdb':
    charset        => 'latin1',
    collate        => 'latin1_swedish_ci',
    user  => 'root',
    password => 'root',
    host     => 'qaamysql',
    sql => "/mnt/dbscripts/apimgt/mysql.sql",
 }

mysql::db { 'userdb':
    user  => 'apimg',
    password => 'apimg',
    host     => 'qaamysql',
    sql => "/mnt/dbscripts/mysql.sql",
 }

mysql::db { 'regdb':
    user  => 'apimg',
    password => 'apimg',
    host     => 'qaamysql',
    sql => "/mnt/dbscripts/mysql.sql",
 }

}
