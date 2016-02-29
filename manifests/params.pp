# == Class: gitolite::params
#
# This is a container class with default parameters for gitolite classes.
class gitolite::params {
  $package_ensure = 'present'

  case $::osfamily {
    'Debian': {
      case $::lsbdistcodename {
        'squeeze', 'wheezy', 'lucid', 'precise': {
          $cmd_install  = 'gl-setup -q'
          $package_name = 'gitolite'
          $version      = '2'
        }
        default: {
          $cmd_install  = 'gitolite setup -pk'
          $package_name = 'gitolite3'
          $version      = '3'
        }
      }
      $group_name = $package_name
      $home_dir   = "/var/lib/${package_name}"
      $user_name  = $package_name
    }
    'RedHat': {
      if versioncmp($::operatingsystemrelease, '6') < 0 {
        $cmd_install  = 'gl-setup -q'
        $package_name = 'gitolite'
        $version      = '2'
      } else {
        $cmd_install  = 'gitolite setup -pk'
        $package_name = 'gitolite3'
        $version      = '3'
      }
      $group_name = $package_name
      $home_dir   = "/var/lib/${package_name}"
      $user_name  = $package_name
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
      fail("Unsupported OS family: ${::osfamily}")
    }
  }

  $allow_local_code    = false
  $git_config_keys     = ''
  $local_code_in_repo  = false
  $local_code_path     = 'local'
  $manage_home_dir     = true
  $manage_user         = true
  $repo_specific_hooks = false
  $umask               = '0077'
}
