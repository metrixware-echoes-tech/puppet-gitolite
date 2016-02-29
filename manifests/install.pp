# Private class
class gitolite::install inherits gitolite {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $gitolite::manage_user {
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
      before           => File[$gitolite::home_dir],
    }
  }

  if $gitolite::manage_home_dir {
    file { $gitolite::home_dir:
      ensure => directory,
      owner  => $gitolite::user_name,
      group  => $gitolite::group_name,
      before => Package[$gitolite::package_name],
    }
  }

  package { $gitolite::package_name:
    ensure => $gitolite::package_ensure,
    alias  => 'gitolite',
  }
}
