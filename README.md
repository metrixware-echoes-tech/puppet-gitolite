# gitolite

[![Build Status](https://travis-ci.org/echoes-tech/puppet-gitolite.svg?branch=master)](https://travis-ci.org/echoes-tech/puppet-gitolite)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with gitolite](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with gitolite](#beginning-with-gitolite)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)
8. [Contributors](#contributors)

## Overview

Puppet module to manage Gitolite installation and configuration.

## Module Description

This module installs and configures [Gitolite](http://gitolite.com/).

## Setup

### Setup Requirements

**WARNING:** For RedHat systems, you may need to add an additional repository like the [EPEL repository](http://fedoraproject.org/wiki/EPEL).
You can use the module [stahnma-epel](https://forge.puppetlabs.com/stahnma/epel) to do this.

### Beginning with gitolite

The quickest way to be up and running using the gitolite module is to copy your public SSH key in the files folder of this module.
So, you can use this syntax:

```puppet
class { 'gitolite':
  admin_key_source => "puppet:///modules/gitolite/id_rsa.pub",
}
```

## Usage

### Use `content` parameter instead of `source` parameter

```puppet
class { 'gitolite':
  admin_key_content => "ssh-dss AAAAB3NzaC1kc3MAAaCBANzDfIs7n5Co8zEa+dWgr6VzPFrTKsFmaG4l1JPa/XZWId9b4J+Cdf53cCCanUt9K8tFOeuo5TEzy+rS+O48G/R+tpv/iY8wJp7gqdBK2j65JPocLTMZ48rprDTNtg35FJZp6gSbiie7iml9QQUFSzAPOWkA6hP/CcEkh3NiCd0RAAAAFQCrQJliYVH1sXBh5ppC+IDa3j/arQAAAIAYHjea9fGUX31fIRENyIqwVxlX7x3e48XnVJNfZrzC+NSI5BhwnDD5Hb9ls0GOq4kSIkTajmCcb+514YgW3jdlRwiFWbfQbf19CJ1Np6165knbBkGJESaG4+dfUGgkrWMP92k4MbXpmMsKterUq6UDVOIwq4Ke2uBa3iHI5VhdlQAAAIAJ3BawCZz5Ft2T+tHjaUulWRrhQnCv3xHQU8Juat71M9iqCKiNQntZoDAiMrf9h9vGg+ya2ILcplf9zdNwOSVGPebF5S4BqY+LrC7tYcjRrWkrQkioywya1y8+Qt9uqksvcRh7T4WC3yMgbG3NqSHKl51ncDVw7gLzoIURt9Oimw== florent@echoes",
}
```

## Reference

### Classes

#### Public Classes

* gitolite: Main class, includes all other classes.

#### Private Classes

* gitolite::install: Handles the packages.
* gitolite::config: Handles the configuration file.

#### Parameters

The following parameters are available in the `::gitolite` class:

##### `package_ensure`

Tells Puppet whether the Gitolite package should be installed, and what version. Valid options: 'present', 'latest', or a specific version number. Default value: 'present'

##### `package_name`

Tells Puppet which Gitolite package to manage. Valid options: string. Default value: varies by operating system

##### `user_name`

Tells Puppet which Gitolite user name to manage. Valid options: string. Default value: varies by operating system

##### `group_name`

Tells Puppet which Gitolite group name to manage. Valid options: string. Default value: varies by operating system

##### `home_dir`

Tells Puppet which Gitolite home directory to manage. Valid options: string containing an absolute path. Default value: '/var/lib/gitolite'

##### `admin_key_source`

Tells Puppet which path of administration SSH key to add to Gitolite. Exclusive with the `content` parameter. Valid options: string. Default value: undef

##### `admin_key_content`

Tells Puppet what content of administration SSH key to add to Gitolite. Exclusive with the `source` parameter. Valid options: string. Default value: undef

##### `git_config_keys`

This setting of `.gitolite.rc` file allows the repo admin to define acceptable gitconfig keys. Valid options: string. Default value: empty
For more details, see : http://gitolite.com/gitolite/rc.html#specific-variables

##### `allow_local_code`

Tells Puppet whether the `LOCAL_CODE` setting of `.gitolite.rc` file is enabled. Valid options: boolean. Default value: false

The value of `LOCAL_CODE` is $ENV{HOME}/local. This option is only available for Gitolite 3.
For more details, see : http://gitolite.com/gitolite/non-core.html#localcode

## Limitations

RedHat and Debian family OSes are officially supported. Tested and built on Debian and CentOS.

##Development

[Echoes Technologies](https://www.echoes-tech.com) modules on the Puppet Forge are open projects, and community contributions are essential for keeping them great.

[Fork this module on GitHub](https://github.com/echoes-tech/puppet-gitolite/fork)

## Contributors

The list of contributors can be found at: https://github.com/echoes-tech/puppet-gitolite/graphs/contributors
