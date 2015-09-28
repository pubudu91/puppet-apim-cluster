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

    class { users: }
    ->
    class { hosts : }
    ->
    class { environment :}
    ->
    class { packages :}
    ->
    class { java :}
#    ->
#    class { maven :}
}
