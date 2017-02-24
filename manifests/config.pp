# Private class
class gitolite::config inherits gitolite {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  file { 'gitolite_admin_key':
    ensure  => file,
    path    => "${gitolite::home_dir}/admin.pub",
    source  => $gitolite::admin_key_source,
    content => $gitolite::admin_key_content,
    owner   => $gitolite::user_name,
    group   => $gitolite::group_name,
    mode    => '0400',
  }->
  exec { 'gitolite_install_admin_key':
    command     => "${gitolite::params::cmd_install} admin.pub",
    path        => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
    user        => $gitolite::user_name,
    cwd         => $gitolite::home_dir,
    environment => "HOME=${gitolite::home_dir}",
    creates     => "${gitolite::home_dir}/projects.list",
    before      => File['gitolite_config'],
  }

  file { 'gitolite_config':
    ensure  => file,
    path    => "${gitolite::home_dir}/.gitolite.rc",
    content => template("${module_name}/gitolite${gitolite::version}.rc.erb"),
    owner   => $gitolite::user_name,
    group   => $gitolite::group_name,
  }
}
