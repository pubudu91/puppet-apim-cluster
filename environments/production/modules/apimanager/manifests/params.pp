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

class apimanager::params {

  $domain               = $wso2base::params::domain
  $package_repo         = $wso2base::params::package_repo
  $local_package_dir    = $wso2base::params::local_package_dir
  $depsync_svn_repo     = $wso2base::params::depsync_svn_repo

  # Master data source information
  # used in all API Manager classes, i.e., gateway, publisher, pubstore, keymanager, apistore
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
  $stats_db_connection_url      = $datasource[stats_db_connection_url]
  $stats_db_user                = $datasource[stats_db_user]
  $stats_db_password            = $datasource[stats_db_password]
  $stats_db_driver_name         = $datasource[stats_db_driver_name]

  #Adding instance common data
  $version                      = $common[version]
  $maintenance_mode             = $common[maintenance_mode]
  $owner                        = $common[owner]
  $group                        = $common[group]
  $svn_url                      = $common[svn_url]
  $svn_username                 = $common[svn_username]
  $svn_password                 = $common[svn_password]
}
