# Private class
class gitolite::install inherits gitolite {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $gitolite::manage_user_bool {
    group { $gitolite::group_name:
      ensure => 'present',
      system => true,
    }->
    user { $gitolite::user_name:
      ensure           => 'present',
      gid              => $gitolite::group_name,
      home             => $gitolite::home_dir,
      password         => '*',
      password_max_age => '99999',
      password_min_age => '0',
      shell            => '/bin/sh',
      system           => true,
    }

    if $gitolite::manage_home_dir_bool {
      User[$gitolite::user_name] {
        before => File['gitolite_home_dir'],
      }
    }
  }

  if $gitolite::manage_home_dir_bool {
    file { 'gitolite_home_dir':
      ensure => directory,
      path   => $gitolite::home_dir,
      owner  => $gitolite::user_name,
      group  => $gitolite::group_name,
      before => Package['gitolite'],
    }
  }

  package { 'gitolite':
    ensure => $gitolite::package_ensure,
    name   => $gitolite::package_name,
  }
}
