# == Class: gitolite
#
class gitolite (
  $admin_key_content   = $gitolite::params::admin_key_content,
  $admin_key_source    = $gitolite::params::admin_key_source,
  $allow_local_code    = $gitolite::params::allow_local_code,
  $git_config_keys     = $gitolite::params::git_config_keys,
  $group_name          = $gitolite::params::group_name,
  $home_dir            = $gitolite::params::home_dir,
  $local_code_in_repo  = $gitolite::params::local_code_in_repo,
  $local_code_path     = $gitolite::params::local_code_path,
  $manage_home_dir     = $gitolite::params::manage_home_dir,
  $manage_user         = $gitolite::params::manage_user,
  $package_ensure      = $gitolite::params::package_ensure,
  $package_name        = $gitolite::params::package_name,
  $repo_specific_hooks = $gitolite::params::repo_specific_hooks,
  $umask               = $gitolite::params::umask,
  $user_name           = $gitolite::params::user_name,
  $version             = $gitolite::params::version,
) inherits gitolite::params {
  # <stringified variable handling>
  if is_string($manage_home_dir) == true {
    $manage_home_dir_bool = str2bool($manage_home_dir)
  } else {
    $manage_home_dir_bool = $manage_home_dir
  }

  if is_string($manage_user) == true {
    $manage_user_bool = str2bool($manage_user)
  } else {
    $manage_user_bool = $manage_user
  }

  if is_string($allow_local_code) == true {
    $allow_local_code_bool = str2bool($allow_local_code)
  } else {
    $allow_local_code_bool = $allow_local_code
  }

  if is_string($local_code_in_repo) == true {
    $local_code_in_repo_bool = str2bool($local_code_in_repo)
  } else {
    $local_code_in_repo_bool = $local_code_in_repo
  }

  if is_string($repo_specific_hooks) == true {
    $repo_specific_hooks_bool = str2bool($repo_specific_hooks)
  } else {
    $repo_specific_hooks_bool = $repo_specific_hooks
  }
  # </stringified variable handling>

  # <variable validations>
  if $admin_key_source and $admin_key_content {
    fail 'Parameters `admin_key_source` and `admin_key_content` are mutually exclusive'
  }
  if $admin_key_source {
    validate_string($admin_key_source)
  }
  if $admin_key_content {
    validate_string($admin_key_content)
  }

  validate_bool($allow_local_code_bool)
  validate_string($git_config_keys)
  validate_string($group_name)
  validate_absolute_path($home_dir)
  validate_bool($local_code_in_repo_bool)
  validate_string($local_code_path)
  validate_bool($manage_home_dir_bool)
  validate_bool($manage_user_bool)
  validate_string($package_ensure)
  validate_string($package_name)
  validate_bool($repo_specific_hooks_bool)
  validate_re($umask, '^0[0-7][0-7][0-7]$')
  validate_string($user_name)
  validate_re($version, ['2', '3'])

  if $local_code_in_repo_bool and ! $allow_local_code_bool {
    fail 'Parameter `allow_local_code` must be true to enable `local_code_in_repo`'
  }
  # </variable validations>

  anchor { "${module_name}::begin": } ->
  class { "${module_name}::install": } ->
  class { "${module_name}::config": } ->
  anchor { "${module_name}::end": }
}
