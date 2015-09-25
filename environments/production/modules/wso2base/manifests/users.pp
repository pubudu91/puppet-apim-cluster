#
class wso2base::users {
    $users = ["wso2user"]

    user { $users:
        ensure  => present,
        shell      => '/bin/bash',
        managehome => true,
    }
}
