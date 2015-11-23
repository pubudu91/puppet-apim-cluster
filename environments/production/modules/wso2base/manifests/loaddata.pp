#
# Load data
# Define stages
#
$common     = hiera("nodeinfo")
$datasource = hiera("datasources")

stage { 'configure': require => Stage['main'] }
stage { 'deploy': require => Stage['configure'] }
