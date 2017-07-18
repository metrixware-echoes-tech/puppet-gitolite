# == Class: gitolite::params
#
# This is a container class with default parameters for gitolite classes.
class gitolite::params {
  $admin_key_content   = undef
  $admin_key_source    = undef
  $allow_local_code    = false
  $git_config_keys     = ''
  $local_code_in_repo  = false
  $local_code_path     = 'local'
  $manage_home_dir     = true
  $manage_user         = true
  $mirror_hostname     = undef
  $package_ensure      = 'present'
  $repo_specific_hooks = false
  $umask               = '0077'

  # <OS family handling>
  case $::osfamily {
    'Debian': {
      case $::lsbdistcodename {
        'squeeze', 'wheezy', 'lucid', 'precise': {
          $version = '2'
        }
        'jessie', 'trusty', 'xenial': {
          $version = '3'
        }
        default: {
          fail("gitolite supports Debian 6 (squeeze), 7 (wheezy) and 8 (jessie) \
and Ubuntu 10.04 (lucid), 12.04 (precise), 14.04 (trusty) and 16.04 (xenial). \
Detected lsbdistcodename is <${::lsbdistcodename}>.")
        }
      }
    }
    'RedHat': {
      case $::operatingsystemmajrelease {
        '5': {
          $version = '2'
        }
        '6', '7': {
          $version = '3'
        }
        default: {
          fail("gitolite supports EL 5, 6 and 7. Detected operatingsystemmajrelease is <${::operatingsystemmajrelease}>.")
        }
      }
    }
    'Suse': {
      $cmd_install  = 'gitolite setup -pk'
      $group_name   = 'git'
      $home_dir     = '/srv/git'
      $package_name = 'gitolite'
      $user_name    = 'git'
      $version      = '3'
    }
    default: {
      fail("gitolite supports osfamilies Debian, RedHat and Suse. Detected osfamily is <${::osfamily}>.")
    }
  }

  if $::osfamily != 'Suse' {
    if $version == '2' {
      $cmd_install  = 'gl-setup -q'
      $package_name = 'gitolite'
    } else { # $version == '3'
      $cmd_install  = 'gitolite setup -pk'
      $package_name = 'gitolite3'
    }
    $group_name = $package_name
    $home_dir   = "/var/lib/${package_name}"
    $user_name  = $package_name
  }
  # </OS family handling>
}
