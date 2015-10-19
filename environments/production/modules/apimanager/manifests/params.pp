# ----------------------------------------------------------------------------
#  Copyright 2005-2013 WSO2, Inc. http://www.wso2.org
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
# ----------------------------------------------------------------------------
#
# Class apimanager::params
#
# This class manages APIM parameters
#
# Parameters:
#
# Usage: Uncomment the variable and assign a value to override the nodes.pp value
#
#

class apimanager::params {

  $domain               = $wso2base::params::domain
  $package_repo         = $wso2base::params::package_repo
  $local_package_dir    = $wso2base::params::local_package_dir
  $depsync_svn_repo     = $wso2base::params::depsync_svn_repo

  # Service subdomains
  $am_subdomain         = $wso2base::params::am_subdomain 
  $gateway_subdomain    = $wso2base::params::gateway_subdomain
  $keymanager_subdomain = $wso2base::params::keymanager_subdomain 
  $apistore_subdomain   = $wso2base::params::apistore_subdomain
  $publisher_subdomain  = $wso2base::params::publisher_subdomain
  $management_subdomain = $wso2base::params::management_subdomain

  # Service ports
  $gateway_mgt_https_port= '8243'
  $gateway_http_port     = '8280'
  $gateway_https_port    = '8243'
  $keymanager_mgt_https_port= '8243'
  $keymanager_http_port     = '8280'
  $keymanager_https_port    = '8243'

  $admin_username       = 'admin'
  $admin_password       = 'admin'

  # BAM settings
  $usage_tracking        = "false"
  $receiver_port         = "7612"
  $receiver1_url         = "localhost"


  # MySQL server configuration details
  ## 'mysql.wso2.com'
  $mysql_server         = "mysql.${domain}" 
  $mysql_port           = '3306'
  $max_connections      = '100000'
  $max_active           = '150'
  $max_wait             = '360000'

  # registry 
  $registry_database    = 'registry' 
  $registry_user        = 'registry'
  $registry_password    = 'ycJaCboyUo'

  # governance
  $userstore_database   = 'userstore'
  $userstore_user       = 'userstore'
  $userstore_password   = 'sUAKn09o5J'

  # Config Database
  $config_database      = 'config'
  $configdb_user        = 'config'
  $configdb_password    = 'Kn09aCboH'
  
  # apimanager database 
  $apim_database        = 'apimgt'
  $apim_user            = 'apim'
  $apim_password        = 'KeoNeDAe'

  # stats database
  $amstats_user         = 'amstats'
  $amstats_password     = 'keDweNjseR'
  $amstats_database     = 'amstats'

  # Depsync settings
  $svn_user             = 'wso2'
  $svn_password         = 'wso2123'

  # Auto-scaler
  $auto_scaler_epr      = 'http://xxx:9863/services/AutoscalerService/'

  #user-mgt ldap
  $usermgt              = ''

  #LDAP settings 
  $ldap_connection_uri      = 'ldap://localhost:10389'
  $bind_dn                  = 'uid=admin,ou=system'
  $bind_dn_password         = 'adminpassword'
  $user_search_base         = 'ou=system'
  $group_search_base        = 'ou=system'
  $sharedgroup_search_base  = 'ou=SharedGroups,dc=wso2,dc=org'

  # Master data source information
  # used in all API Manager classes, i.e., gateway, publisher, pubstore, keymanager, apistore
  $datasource                   = hiera("datasources")
  $registry_db_connection_url   = $datasource[registry_db_connection_url]
  $registry_db_user             = $datasource[registry_db_user]
  $registry_db_password         = $datasource[registry_db_password]
  $registry_db_driver_name      = $datasource[registry_db_driver_name]
  $userstore_db_connection_url  = $datasource[userstore_db_connection_url]
  $userstore_db_user            = $datasource[userstore_db_user]
  $userstore_db_password        = $datasource[userstore_db_password]
  $userstore_db_driver_name     = $datasource[userstore_db_driver_name]
  $apim_db_connection_url       = $datasource[apim_db_connection_url]
  $apim_db_user                 = $datasource[apim_db_user]
  $apim_db_password             = $datasource[apim_db_password]
  $apim_db_driver_name          = $datasource[apim_db_driver_name]

}
