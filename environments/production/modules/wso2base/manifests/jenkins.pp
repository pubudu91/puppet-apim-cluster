#
# This will write the required hostnames to jenkins instance's 
# /etc/hosts file.
# This is needed to run the platform tests successfully
#
node /jenkins/ {
  class { wso2base::hosts:}
}
