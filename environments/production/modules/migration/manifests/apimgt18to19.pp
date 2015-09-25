class migration::apimgt18to19($rootUser,$rootPassword,$user,$password,$host,$apimgtdb,$userdb,$regdb)
{

staging::file { 'zip':
  source => 'puppet:///files/mysql-connector.zip',
  target => '/tmp/',
}
}

