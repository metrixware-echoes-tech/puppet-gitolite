class gitolite (
  $package_ensure      = $gitolite::params::package_ensure,
  $package_name        = $gitolite::params::package_name,
  $version             = $gitolite::params::version,
  $user_name           = $gitolite::params::user_name,
  $group_name          = $gitolite::params::group_name,
  $home_dir            = $gitolite::params::home_dir,
  $manage_home_dir     = $gitolite::params::manage_home_dir,
  $manage_user         = $gitolite::params::manage_user,
  $admin_key_source    = undef,
  $admin_key_content   = undef,
  $git_config_keys     = $gitolite::params::git_config_keys,
  $umask               = $gitolite::params::umask,
  $allow_local_code    = $gitolite::params::allow_local_code,
  $local_code_in_repo  = $gitolite::params::local_code_in_repo,
  $repo_specific_hooks = $gitolite::params::repo_specific_hooks,
) inherits gitolite::params {
  validate_string($package_ensure)
  validate_string($package_name)
  validate_re($version, [2, 3])
  validate_string($user_name)
  validate_string($group_name)
  validate_absolute_path($home_dir)
  validate_bool($manage_home_dir)
  validate_bool($manage_user)

  if $admin_key_source and $admin_key_content {
    fail 'Parameters `admin_key_source` and `admin_key_content` are mutually exclusive'
  }
  if $admin_key_source {
    validate_string($admin_key_source)
  }
  if $admin_key_content {
    validate_string($admin_key_content)
  }

  validate_string($git_config_keys)
  validate_re($umask, '^0[0-7][0-7][0-7]$')
  validate_bool($allow_local_code)
  validate_bool($local_code_in_repo)
  if $local_code_in_repo and ! $allow_local_code {
    fail 'Parameter `allow_local_code` must be true to enable `local_code_in_repo`'
  }
  validate_bool($repo_specific_hooks)

  anchor { "${module_name}::begin": } ->
  class { "${module_name}::install": } ->
  class { "${module_name}::config": } ->
  anchor { "${module_name}::end": }
}
