#
class wso2base::users {
    $users = hiera("nodeinfo")

    user { $users[owner]:
        ensure  => present,
        shell      => '/bin/bash',
        managehome => true,
    }
}
