require 'spec_helper'

describe 'gitolite', :type => 'class' do
  let(:facts) {{ :is_virtual => 'false' }}

  ['Debian', 'RedHat'].each do |system|
    context "when on system #{system}" do

      let (:facts) do
        case system
        when 'RedHat'
          super().merge({ :osfamily => system, :operatingsystemrelease=> '7.0' })
        else
          super().merge({ :osfamily => system })
        end
      end

      describe 'validations' do
        [:package_name, :user_name, :group_name, :admin_key_source, :admin_key_content, :git_config_keys].each do |param|
          context "should validate #{param} is a string" do
            let(:params) { { param => 10, :admin_key_content => 'key' } }
            it { expect { should raise_error(/10 is not a string/) } }
          end
        end

        [:manage_user, :allow_local_code, :local_code_in_repo, :repo_specific_hooks].each do |param|
          context "should validate #{param} is a bool" do
            let(:params) { { param => 10, :admin_key_content => 'key' } }
            it { should compile.and_raise_error(/is not a boolean/) }
          end
        end

        context 'should validate home_dir is an absolute path' do
          let(:params) { { :home_dir => 'foo/bar', :admin_key_content => 'key' } }
          it { should compile.and_raise_error(/"foo\/bar" is not an absolute path/) }
        end

        context 'should validate valid umask' do
          let(:params) { { :umask => '0999', :admin_key_content => 'key' } }
          it { should compile.and_raise_error(/"0999" does not match/) }
        end

        context 'should not allow admin_key_source and admin_key_content' do
          let(:params) { { :admin_key_source => 'foo', :admin_key_content => 'bar' } }
          it { should compile.and_raise_error(/are mutually exclusive/) }
        end
      end # Validations

      it { should contain_class('gitolite::install').that_comes_before('Class[gitolite::config]') }
      it { should contain_class('gitolite::config') }

      describe 'gitolite::install' do
        describe 'default' do
          let(:params) { { :admin_key_content => 'key'} }
          it { should contain_group('gitolite3') }
          it { should contain_user('gitolite3').with(:home => '/var/lib/gitolite3') }
          it { should contain_file('/var/lib/gitolite3').with(:owner => 'gitolite3', :group => 'gitolite3')}
          it { should contain_package('gitolite3').with(:ensure => 'present')}
        end

        describe 'configure user/group' do
          let(:params) { { :user_name => 'kirk', :group_name => 'captain', :admin_key_content => 'key' } }
          it { should contain_group('captain') }
          it { should contain_user('kirk')}
          it { should contain_file('/var/lib/gitolite3').with(:owner => 'kirk', :group => 'captain')}
        end

        describe 'without user' do
          let(:params) { { :manage_user => false, :admin_key_content => 'key' } }
          it { should_not contain_user('gitolite3') }
          it { should_not contain_group('gitolite3') }
        end

        describe 'latest package' do
          let(:params) { { :package_ensure => 'latest', :admin_key_content => 'key' } }
          it { should contain_package('gitolite3').with(:ensure => 'latest') }
        end
      end # gitolite::install

      describe 'gitolite::config' do
        describe 'default' do
          let(:params) { { :admin_key_content => 'key' } }
          it { should contain_file('/var/lib/gitolite3/admin.pub').with(:source => nil, :content => 'key', :owner => 'gitolite3', :group => 'gitolite3')}
          it { should contain_exec('gitolite setup -pk admin.pub').with(:environment => 'HOME=/var/lib/gitolite3') }
          it { should contain_file('/var/lib/gitolite3/.gitolite.rc').with(:content => /UMASK\s+=>\s+0077,/) }
          it { should contain_file('/var/lib/gitolite3/.gitolite.rc').with(:content => /GIT_CONFIG_KEYS\s+=>\s+'',/) }
          it { should contain_file('/var/lib/gitolite3/.gitolite.rc').with(:content => /^\s+# LOCAL_CODE\s+=>\s+"\$ENV\{HOME\}\/local",/) }
          it { should contain_file('/var/lib/gitolite3/.gitolite.rc').with(:content => /^\s+# LOCAL_CODE\s+=>\s+"\$rc\{GL_ADMIN_BASE\}\/local"/) }
          it { should contain_file('/var/lib/gitolite3/.gitolite.rc').with(:content => /^\s+# 'repo-specific-hooks'/) }
        end

        describe 'with admin_key_source' do
          let(:params) { { :admin_key_source => 'puppet:///data/gitolite.pub' } }
          it { should contain_file('/var/lib/gitolite3/admin.pub').with(:source => 'puppet:///data/gitolite.pub', :content => nil) }
        end

        describe 'updated home dir' do
          let(:params) { { :home_dir => '/data/git', :admin_key_content => 'key' } }
          it { should contain_file('/data/git/admin.pub') }
          it { should contain_exec('gitolite setup -pk admin.pub').with(:environment => 'HOME=/data/git') }
          it { should contain_file('/data/git/.gitolite.rc') }
        end

        # These next two are confusing because the template negates the option by commenting the line.
        # Makes sense, but somewhat hard to follow
        describe 'allow local code' do
          let(:params) { { :allow_local_code => true, :local_code_in_repo => false, :admin_key_content => 'key' } }
          it { should contain_file('/var/lib/gitolite3/.gitolite.rc').with(:content => /^\s+LOCAL_CODE\s+=>\s+"\$ENV\{HOME\}\/local",/) }
          it { should contain_file('/var/lib/gitolite3/.gitolite.rc').with(:content => /^\s+# LOCAL_CODE\s+=>\s+"\$rc\{GL_ADMIN_BASE\}\/local"/) }
        end

        describe 'allow local code in repo' do
          let(:params) { { :allow_local_code => true, :local_code_in_repo => true, :admin_key_content => 'key' } }
          it { should contain_file('/var/lib/gitolite3/.gitolite.rc').with(:content => /^\s+# LOCAL_CODE\s+=>\s+"\$ENV\{HOME\}\/local",/) }
          it { should contain_file('/var/lib/gitolite3/.gitolite.rc').with(:content => /^\s+LOCAL_CODE\s+=>\s+"\$rc\{GL_ADMIN_BASE\}\/local"/) }
        end

        describe 'setting local code path' do
          let(:params) { { :allow_local_code => true, :local_code_path => '.gitolite/local', :admin_key_content => 'key' } }
          it { should contain_file('/var/lib/gitolite3/.gitolite.rc').with(:content => /^\s+LOCAL_CODE\s+=>\s+"\$ENV\{HOME\}\/\.gitolite\/local",/) }
        end

        describe 'repo-specific-hooks' do
          let(:params) { { :repo_specific_hooks => true, :admin_key_content => 'key' } }
          it { should contain_file('/var/lib/gitolite3/.gitolite.rc').with(:content => /^\s+'repo-specific-hooks'/) }
        end
      end #gitolite::config
    end #when on system #{system}
  end #system
end
