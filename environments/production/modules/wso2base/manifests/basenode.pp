# This is the base node required by all WSO2 product puppet modules
# HOW TO INCLUDE
# e.g.: node /publisher/ inherits base {
node base {
    class { wso2base:
            stage => configure,
        }
}
