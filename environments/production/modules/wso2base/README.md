# wso2base  

#### Table of Contents  

1. [Module Description - What the module does and why it is useful](#module-description)
2. [Backwards compatibility information](#backwards-compatibility)
3. [Setup - The basics of getting started with wso2base module](#setup)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)

## Module Description

This is the base puppet module required by all WSO2 products puppet modules  

## Setup
Copy the required files to ```/etc/puppet/files/java```  
Go through the ```FilesToCopyHere.txt``` readme file.
   
#### Customize JDK versions
e.g.: Installing JDK 7 Update 79 on Ubuntu x64  
* Download and copy the file ```jdk-7u79-linux-x64.gz``` to  ```/etc/puppet/files/java``` location.  
* Update the java section of ```/etc/puppet/modules/wso2base/manifests/params.pp```   
as follows,  
```
# Java
    $java_home  = "jdk1.7.0_79"
    $package    = "jdk-7u79-linux-x64.gz"
```

## Usage

### Sample site.pp file
```
node default {  
}  
node base {  
    class { wso2base: }  
}  
# To test your puppet code use this block  
node 'puppetagent' inherits base{  
}   
```

## Reference

### Classes

#### Public classes

* [`wso2base`](#wso2base): Installs and manages the WSO2 base module

#### Private classes

* `wso2base::params`: Builds a hash of core module information.

### Parameters


## Limitations

This module has been tested on:

* Ubuntu 12.04, 14.04

Testing on other platforms has been minimal and cannot be guaranteed.

## Development

This module is maintained by WSO2, Inc.

### Authors

* Suhan Dharmasuriya
* Malintha Adikari
* Thilina Piyasundara


