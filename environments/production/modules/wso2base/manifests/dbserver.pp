#
# Performing database cleanup
# Currently supported
# 1. MySQL
#
# This will ONLY cleanup the databases apimgtdb, userdb, regdb, statsdb in MySQL instance
# This has to be triggered after each test execution
#
node /dbserver/ {
  $datasource = hiera("datasources")
  class { "cleandb::mysql":
    apim_version  => $common[version],
    user          => $datasource[db_root_user],
    password      => $datasource[db_root_user_password],
    host          => $datasource[host],
  }
}
