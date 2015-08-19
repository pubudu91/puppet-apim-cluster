#
class wso2base::users {
    $users = ["kurumba"]

    user { $users:
        ensure  => present,
        shell      => '/bin/bash',
        managehome => true,
    }
}
