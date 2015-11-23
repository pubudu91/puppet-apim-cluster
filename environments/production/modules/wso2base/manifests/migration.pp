#
# Migration related R & D
#
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
