# Class: wso2base
#
# Full description of class wso2base here.
#
# Examples
#
#  class { wso2base:
#    java => 'false',
#  }
#
# Authors
#
# Thilina Piyasundara <mail@thilina.org>
#
class wso2base (
    ) inherits params {

    $java = hiera("java")

    class { users: }
    ->
    class { hosts : }
    ->
    class { environment :}
    ->
    class { packages :}
    ->
    class { java :
        java_home  => $java[java_home],
        package    => $java[java_package],
        java_dir   => $java[java_dir],
    }
#    ->
#    class { maven :}
}
