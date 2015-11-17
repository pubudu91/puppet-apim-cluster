#
class wso2base::users (
    $owner      = $wso2base::params::owner,
    $group      = $wso2base::params::group,
    ) {

    user { $owner:
        ensure  => present,
        shell      => '/bin/bash',
        managehome => true,
    }
}
