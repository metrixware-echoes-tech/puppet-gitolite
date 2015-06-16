# Private class
class gitolite::install inherits gitolite {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  group { 'gitolite':
    ensure => 'present',
    system => true,
  }->
  user { 'gitolite':
    ensure           => 'present',
    gid              => 'gitolite',
    home             => $gitolite::home_dir,
    password         => '*',
    password_max_age => '99999',
    password_min_age => '0',
    shell            => '/bin/sh',
    system           => true,
  }->
  file { $gitolite::home_dir:
    ensure => directory,
    owner  => 'gitolite',
    group  => 'gitolite',
  }->
  package { $gitolite::package_name:
    ensure => $gitolite::package_ensure,
    alias  => 'gitolite',
  }
}
