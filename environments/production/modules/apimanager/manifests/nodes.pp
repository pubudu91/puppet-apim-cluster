node /publisher/ inherits base {
    $publisher = hiera("publisher")
      class { "apimanager::publisher":
        version                         => $common[version],
        offset                          => $publisher[offset],
        depsync                         => $publisher[depsync],
        local_member_port               => $publisher[local_member_port],
        clustering                      => $publisher[clustering],
        membershipScheme                => $publisher[membershipScheme],
        cloud                           => $publisher[cloud],
        cluster_domain                  => $publisher[cluster_domain],
        sub_cluster_domain              => $publisher[sub_cluster_domain],
        maintenance_mode                => $common[maintenance_mode],
        owner                           => $common[owner],
        group                           => $common[group],
        members                         => $publisher[members],
        port_mapping                    => $publisher[port_mapping],
        stage                           => $publisher[stage],
    }
}

node /pubstore/ inherits base {
 $pubstore = hiera("pubstore")
      class { "apimanager::pubstore":
        version                         => $common[version],
        offset                          => $pubstore[offset],
        local_member_port               => $pubstore[local_member_port],
        clustering                      => $pubstore[clustering],
        membershipScheme                => $pubstore[membershipScheme],
        cloud                           => $pubstore[cloud],
        sub_cluster_domain              => $pubstore[sub_cluster_domain],
        maintenance_mode                => $common[maintenance_mode],
        owner                           => $common[owner],
        group                           => $common[group],
        members                         => $pubstore[members],
        port_mapping                    => $pubstore[port_mapping],
        stage                           => $pubstore[stage],
    }
}

node /store/ inherits base {
  $store = hiera("store")
      class { "apimanager::apistore":
        version                         => $common[version],
        offset                          => $store[offset],
        depsync                         => $store[depsync],
        local_member_port               => $store[local_member_port],
        clustering                      => $store[clustering],
        membershipScheme                => $store[membershipScheme],
        cloud                           => $store[cloud],
        cluster_domain                  => $store[cluster_domain],
        sub_cluster_domain              => $store[sub_cluster_domain],
        maintenance_mode                => $common[maintenance_mode],
        owner                           => $common[owner],
        group                           => $common[group],
        members                         => $store[members],
        port_mapping                    => $store[port_mapping],
        stage                           => $store[stage],
    }
}

node /keymanager/ inherits base {
    $keymanager = hiera("keymanager")
      class { "apimanager::keymanager":
        version                         => $common[version],
        offset                          => $keymanager[offset],
        depsync                         => $keymanager[depsync],
        local_member_port               => $keymanager[local_member_port],
        clustering                      => $keymanager[clustering],
        membershipScheme                => $keymanager[membershipScheme],
        cloud                           => $keymanager[cloud],
        sub_cluster_domain              => $keymanager[sub_cluster_domain],
        maintenance_mode                => $common[maintenance_mode],
        owner                           => $common[owner],
        group                           => $common[group],
        members                         => $keymanager[members],
        port_mapping                    => $keymanager[port_mapping],
        stage                           => $keymanager[stage],
    }
}

node /gateway/ inherits base {
 $gateway = hiera("gateway")
      class { "apimanager::gateway":
        version                         => $common[version],
        offset                          => $gateway[offset],
        depsync_enabled                 => $gateway[depsync_enabled],
        local_member_port               => $gateway[local_member_port],
        clustering                      => $gateway[clustering],
        membershipScheme                => $gateway[membershipScheme],
        cloud                           => $gateway[cloud],
        sub_cluster_domain              => $gateway[sub_cluster_domain],
        maintenance_mode                => $common[maintenance_mode],
        owner                           => $common[owner],
        group                           => $common[group],
        members                         => $gateway[members],
        port_mapping                    => $gateway[port_mapping],
        stage                           => $gateway[stage],
        svn_url                         => $common[svn_url],
        svn_username                    => $common[svn_username],
        svn_password                    => $common[svn_password],
        tokenPersistenceProcessor       => $gateway[TokenPersistenceProcessor],
        removeOpenIDConnect             => $gateway[removeOpenIDConnect],
    }
}

