#
class wso2base::packages {
    $packages = ["htop", "lsof","unzip","sysstat","telnet", "git", "less", "tree"]

    package { $packages:
        ensure  => installed,
    }	
}
