## 2017-02-28 - Release 1.0.0
### Summary
This release fixes typo and  adds a lot of test improvements.

## 2015-02-29 - Release 0.4.0
### Summary
This release adds options to custom the `.gitolite.rc` files and many tests.

#### Features
- Added parameter to set local code path
- Added parameter to manage Gitolite version

#### Tests
- Improved Travis configuration
- Added specs

#### Bugfixes
- Fixed bad permissions on PuppetLabs forge package

## 2015-10-12 - Release 0.3.0
### Summary
This release adds many options to custom the `.gitolite.rc` file.

#### Features
- Added parameter to store local code in gitolite-admin repo
- Added parameter to enable repo-specific-hooks feature
- Added manage_user parameter to control whether this module manages user/group resources
- Added umask parameter

## 2015-09-17 - Release 0.2.2
### Summary
This release fixes a typo for PE2015.2.

## 2015-08-06 - Release 0.2.1
### Summary
This release updates metadata, the README file, as well as  test improvements.

#### Tests
- Added future parser in Travis matrix.

##2015-06-16 - Release 0.2.0
###Summary
This release adds the ability to manage some options of Gitolite configuration file.

####Features
- Added template of `.gitolite.rc` file
- Added `git_config_keys` parameter to `gitolite` class and to the template of configuration file.
- Added `allow_local_code` parameter to `gitolite` class.

##2015-06-16 - Release 0.1.2
###Summary
This is the initial release

####Fixed
- Contains default stdlib dependency and licence syntax in metadata.json

##2015-06-16 - Release 0.1.0
###Summary
This is the initial release

####Features
- Installs and configures Gitolite for Debian, Ubuntu, RedHat and CentOS
