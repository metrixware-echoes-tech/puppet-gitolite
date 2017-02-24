require 'spec_helper'
describe 'gitolite', :type => 'class' do
  platforms = {
    'debian6' =>
      { :osfamily          => 'Debian',
        :release           => '6.0',
        :majrelease        => '6',
        :lsbdistcodename   => 'squeeze',
        :packages          => 'gitolite',
        :package_name     => 'gitolite',
        :gitolite_version  => '2',
        :cmd_install       => 'gl-setup -q',
        :group_name        => 'gitolite',
        :user_name         => 'gitolite',
      },
    'debian7' =>
      { :osfamily          => 'Debian',
        :release           => '7.0',
        :majrelease        => '7',
        :lsbdistcodename   => 'wheezy',
        :packages          => 'gitolite',
        :package_name     => 'gitolite',
        :gitolite_version  => '2',
        :cmd_install       => 'gl-setup -q',
        :group_name        => 'gitolite',
        :user_name         => 'gitolite',
      },
    'debian8' =>
      { :osfamily          => 'Debian',
        :release           => '8.0',
        :majrelease        => '8',
        :lsbdistcodename   => 'jessie',
        :packages          => 'gitolite',
        :package_name     => 'gitolite3',
        :gitolite_version  => '3',
        :cmd_install       => 'gitolite setup -pk',
        :group_name        => 'gitolite3',
        :user_name         => 'gitolite3',
      },
    'el5' =>
      { :osfamily          => 'RedHat',
        :release           => '5.0',
        :majrelease        => '5',
        :lsbdistcodename   => nil,
        :packages          => 'gitolite',
        :package_name     => 'gitolite',
        :gitolite_version  => '2',
        :cmd_install       => 'gl-setup -q',
        :group_name        => 'gitolite',
        :user_name         => 'gitolite',
      },
    'el6' =>
      { :osfamily          => 'RedHat',
        :release           => '6.0',
        :majrelease        => '6',
        :lsbdistcodename   => nil,
        :packages          => 'gitolite',
        :package_name     => 'gitolite3',
        :gitolite_version  => '3',
        :cmd_install       => 'gitolite setup -pk',
        :group_name        => 'gitolite3',
        :user_name         => 'gitolite3',
      },
    'el7' =>
      { :osfamily          => 'RedHat',
        :release           => '7.0',
        :majrelease        => '7',
        :lsbdistcodename   => nil,
        :packages          => 'gitolite',
        :package_name     => 'gitolite3',
        :gitolite_version  => '3',
        :cmd_install       => 'gitolite setup -pk',
        :group_name        => 'gitolite3',
        :user_name         => 'gitolite3',
      },
    'ubuntu1004' =>
      { :osfamily          => 'Debian',
        :release           => '10.04',
        :majrelease        => '10',
        :lsbdistcodename   => 'lucid',
        :packages          => 'gitolite',
        :package_name     => 'gitolite',
        :gitolite_version  => '2',
        :cmd_install       => 'gl-setup -q',
        :group_name        => 'gitolite',
        :user_name         => 'gitolite',
      },
    'ubuntu1204' =>
      { :osfamily          => 'Debian',
        :release           => '12.04',
        :majrelease        => '12',
        :lsbdistcodename   => 'precise',
        :packages          => 'gitolite',
        :package_name     => 'gitolite',
        :gitolite_version  => '2',
        :cmd_install       => 'gl-setup -q',
        :group_name        => 'gitolite',
        :user_name         => 'gitolite',
      },
    'ubuntu1404' =>
      { :osfamily          => 'Debian',
        :release           => '14.04',
        :majrelease        => '14',
        :lsbdistcodename   => 'trusty',
        :packages          => 'gitolite',
        :package_name     => 'gitolite3',
        :gitolite_version  => '3',
        :cmd_install       => 'gitolite setup -pk',
        :group_name        => 'gitolite3',
        :user_name         => 'gitolite3',
      },
    'ubuntu1604' =>
      { :osfamily          => 'Debian',
        :release           => '16.04',
        :majrelease        => '16',
        :lsbdistcodename   => 'xenial',
        :packages          => 'gitolite',
        :package_name     => 'gitolite3',
        :gitolite_version  => '3',
        :cmd_install       => 'gitolite setup -pk',
        :group_name        => 'gitolite3',
        :user_name         => 'gitolite3',
      },
  }

  describe 'with just an admin_key_content and default values for parameters on' do
    platforms.sort.each do |k, v|
      context "#{k}" do
        let :facts do
          { :lsbdistcodename           => v[:lsbdistcodename],
            :osfamily                  => v[:osfamily],
            :kernelrelease             => v[:release],        # Solaris specific
            :operatingsystemrelease    => v[:release],        # Linux specific
            :operatingsystemmajrelease => v[:majrelease],
          }
        end

        # If support for another osfamily is added, this should be specified
        # per platform in the platforms hash.
        if v[:osfamily] == 'Suses'
          home_dir = '/srv/git'
        elsif v[:osfamily] == 'Debian' || v[:osfamily] == 'RedHat'
          home_dir = '/var/lib/' + v[:package_name]
        else
          fail 'unsupported osfamily detected'
        end

        it { should compile.with_all_deps }

        it { should contain_class('gitolite') }

        if v[:packages].class == Array
          v[:packages].each do |pkg|
            it do
              should contain_package(pkg).with({
                'ensure'   => 'present',
                'provider' => nil,
              })
            end
          end
        else
          it do
            should contain_package(v[:packages]).with({
              'ensure'   => 'present',
              'provider' => nil,
            })
          end
        end

        it do
          should contain_user(v[:group_name]).with({
            'ensure' => 'present',
            'system' => true,
          })
        end

        it do
          should contain_user(v[:user_name]).with({
            'ensure'           => 'present',
            'gid'              => v[:group_name],
            'home'             => home_dir,
            'password'         => '*',
            'password_max_age' => '99999',
            'password_min_age' => '0',
            'shell'            => '/bin/sh',
            'system'           => true,
            'before'           => 'File[gitolite_home_dir]',
          })
        end

        it do
          should contain_file('gitolite_home_dir').with({
            'ensure'  => 'directory',
            'path'    => home_dir,
            'owner'   => v[:user_name],
            'group'   => v[:group_name],
            'before'  => 'Package[gitolite]',
          })
        end

        it do
          should contain_file('gitolite_admin_key').with({
            'ensure'  => 'file',
            'path'    => home_dir + '/admin.pub',
            'owner'   => v[:user_name],
            'group'   => v[:group_name],
            'mode'    => '0400',
          })
        end

        it do
          should contain_file('gitolite_config').with({
            'ensure'  => 'file',
            'path'    => home_dir + '/.gitolite.rc',
            'owner'   => v[:user_name],
            'group'   => v[:group_name],
          })
        end

        gitolite_config_fixture = File.read(fixtures("gitolite.rc.#{k}"))
        it { should contain_file('gitolite_config').with_content(gitolite_config_fixture) }
      end
    end
  end

  describe 'parameter functionality' do
    let(:facts) do
      {
        :osfamily        => 'Debian',
        :lsbdistcodename => 'jessie',
      }
    end

    context 'when admin_key_source is set to valid string <puppet:///data/gitolite.pub>' do
      let(:params) { { :admin_key_source => 'puppet:///data/gitolite.pub' } }
      it { should contain_file('gitolite_admin_key').with(:source => 'puppet:///data/gitolite.pub', :content => nil) }
    end

    context 'when allow_local_code is set to valid bool <true>' do
      let(:params) { { :allow_local_code => true } }
      it { should contain_file('gitolite_config').with_content(/^\s+LOCAL_CODE\s+=>\s+"\$ENV\{HOME\}\/local",/) }
      it { should contain_file('gitolite_config').with_content(/^\s+# LOCAL_CODE\s+=>\s+"\$rc\{GL_ADMIN_BASE\}\/local"/) }
    end

    context 'when git_config_keys is set to valid string <.*>' do
      let(:params) { { :git_config_keys => '.*' } }
      it { should contain_file('gitolite_config').with_content(/^\s+GIT_CONFIG_KEYS\s+=>\s+'.*',$/) }
    end

    context 'when group_name is set to valid string <captain>' do
      let(:params) { { :group_name => 'captain' } }
      it { should contain_group('captain') }
      it { should contain_file('gitolite_config').with(:group => 'captain')}
    end

    context 'when home_dir is set to valid path </opt/gitolite>' do
      let(:params) { { :home_dir => '/opt/gitolite' } }
      it { should contain_file('gitolite_admin_key').with_path('/opt/gitolite/admin.pub') }
      it { should contain_exec('gitolite_install_admin_key').with(:environment => 'HOME=/opt/gitolite') }
      it { should contain_file('gitolite_home_dir').with_path('/opt/gitolite') }
    end

    context 'when allow_local_code and local_code_in_repo are set to valid bool <true>' do
      let(:params) { { :allow_local_code => true, :local_code_in_repo => true } }
      it { should contain_file('gitolite_config').with_content(/^\s+# LOCAL_CODE\s+=>\s+"\$ENV\{HOME\}\/local",$/) }
      it { should contain_file('gitolite_config').with_content(/^\s+LOCAL_CODE\s+=>\s+"\$rc\{GL_ADMIN_BASE\}\/local"/) }
    end

    context 'when local_code_path is set to valid path <dir>' do
      let(:params) { { :local_code_path => 'dir' } }
      it { should contain_file('gitolite_config').with_content(/^\s+# LOCAL_CODE\s+=>\s+"\$ENV\{HOME\}\/dir",$/) }
    end

    context 'when manage_user is set to valid bool <false>' do
      let(:params) { { :manage_user => false } }
      it { should_not contain_user('gitolite3') }
      it { should_not contain_group('gitolite3') }
    end

    context 'when package_ensure is set to valid string <absent>' do
      let(:params) { { :package_ensure => 'absent' } }
      it { should contain_package('gitolite').with_ensure('absent') }
    end

    context 'when package_name is set to valid string <gitolite4>' do
      let(:params) { { :package_name => 'gitolite4' } }
      it { should contain_package('gitolite').with_name('gitolite4') }
    end

    context 'when repo_specific_hooks is set to valid bool <true>' do
      let(:params) { { :repo_specific_hooks => true } }
      it { should contain_file('gitolite_config').with_content(/^\s+'repo-specific-hooks',/) }
    end

    context 'when umask is set to valid string <0777>' do
      let(:params) { { :umask => '0777' } }
      it { should contain_file('gitolite_config').with_content(/^\s+UMASK\s+=>\s+0777,/) }
    end

    context 'when user_name is set to valid string <captain>' do
      let(:params) { { :user_name => 'kirk' } }
      it { should contain_user('kirk') }
      it { should contain_file('gitolite_config').with(:owner => 'kirk')}
    end
  end

  describe 'failures' do
    let(:facts) do
      {
        :osfamily        => 'Debian',
        :lsbdistcodename => 'jessie',
      }
    end

    context 'when home_dir is set to invalid absolute path <foo/bar>' do
      let(:params) { { :home_dir => 'foo/bar' } }

      it 'should fail' do
        expect do
          should contain_class('gitolite')
        end.to raise_error(Puppet::Error, /"foo\/bar" is not an absolute path/)
      end
    end

    context 'when umask is set to invalid umask <0999>' do
      let(:params) { { :umask => '0999' } }

      it 'should fail' do
        expect do
          should contain_class('gitolite')
        end.to raise_error(Puppet::Error, /"0999" does not match/)
      end
    end

    context 'when set admin_key_source and admin_key_content to string' do
      let(:params) { { :admin_key_source => 'foo', :admin_key_content => 'bar' } }

      it 'should fail' do
        expect do
          should contain_class('gitolite')
        end.to raise_error(Puppet::Error, /are mutually exclusive/)
      end
    end

    context 'when major release of EL is unsupported' do
      let :facts do
        { :osfamily                  => 'RedHat',
          :operatingsystemmajrelease => '4',
        }
      end

      it 'should fail' do
        expect do
          should contain_class('gitolite')
        end.to raise_error(Puppet::Error, /gitolite supports EL 5, 6 and 7\. Detected operatingsystemmajrelease is <4>/)
      end
    end

    context 'when major release of Debian is unsupported' do
      let :facts do
        { :osfamily                  => 'Debian',
          :operatingsystemmajrelease => '4',
          :lsbdistcodename           => 'etch',
        }
      end

      it 'should fail' do
        expect do
          should contain_class('gitolite')
        end.to raise_error(Puppet::Error, /gitolite supports Debian 6 \(squeeze\), 7 \(wheezy\) and 8 \(jessie\) and Ubuntu 10\.04 \(lucid\), 12\.04 \(precise\), 14.04 \(trusty\) and 16.04 \(xenial\). Detected lsbdistcodename is <etch>\./)
      end
    end

    context 'when major release of Ubuntu is unsupported' do
      let :facts do
        { :osfamily                  => 'Debian',
          :operatingsystemmajrelease => '8',
          :lsbdistcodename           => 'hardy',
        }
      end

      it 'should fail' do
        expect do
          should contain_class('gitolite')
        end.to raise_error(Puppet::Error, /gitolite supports Debian 6 \(squeeze\), 7 \(wheezy\) and 8 \(jessie\) and Ubuntu 10\.04 \(lucid\), 12\.04 \(precise\), 14.04 \(trusty\) and 16.04 \(xenial\). Detected lsbdistcodename is <hardy>\./)
      end
    end

    context 'when osfamily is unsupported' do
      let :facts do
        { :osfamily                  => 'Unsupported',
          :operatingsystemmajrelease => '9',
        }
      end

      it 'should fail' do
        expect do
          should contain_class('gitolite')
        end.to raise_error(Puppet::Error, /gitolite supports osfamilies Debian, RedHat and Suse\. Detected osfamily is <Unsupported>\./)
      end
    end
  end

  describe 'variable type and content validations' do
    # set needed custom facts and variables
    let(:facts) do
      {
        :osfamily                  => 'Debian',
        :operatingsystemrelease    => '8.0',
        :operatingsystemmajrelease => '8',
        :lsbdistcodename           => 'jessie',
      }
    end
    let(:validation_params) do
      {
        #:param => 'value',
      }
    end

    context "should validate local_code_in_repo is a bool" do
      let(:params) { { :local_code_in_repo => 10 } }
      it { should compile.and_raise_error(/is not a boolean/) }
    end

    validations = {
      'absolute_path' => {
        :name    => %w(home_dir),
        :valid   => %w(/absolute/filepath /absolute/directory/),
        :invalid => ['invalid', 3, 2.42, %w(array), { 'ha' => 'sh' }],
        :message => 'is not an absolute path',
      },
      'bool_stringified' => {
        :name    => %w(
          manage_home_dir manage_user allow_local_code
          repo_specific_hooks
        ),
        :valid   => [true, 'true', false, 'false'],
        :invalid => ['invalid', 3, 2.42, %w(array), { 'ha' => 'sh' }, nil],
        :message => '(is not a boolean|Unknown type of boolean)',
      },
      'string' => {
        :name    => %w(
          admin_key_content git_config_keys group_name
          local_code_path package_ensure package_name user_name
        ),
        :valid   => ['present'],
        :invalid => [%w(array), { 'ha' => 'sh' }],
        :message => 'is not a string',
      },
      'string_file_source' => {
        :name    => %w(admin_key_source),
        :valid   => %w(puppet:///modules/subject/test),
        :invalid => [%w(array), { 'ha' => 'sh' }],
        :message => 'is not a string',
      },
    }

    validations.sort.each do |type, var|
      var[:name].each do |var_name|
        var[:valid].each do |valid|
          context "with #{var_name} (#{type}) set to valid #{valid} (as #{valid.class})" do
            let(:params) { validation_params.merge({ :"#{var_name}" => valid, }) }
            it { should compile }
          end
        end

        var[:invalid].each do |invalid|
          context "with #{var_name} (#{type}) set to invalid #{invalid} (as #{invalid.class})" do
            let(:params) { validation_params.merge({ :"#{var_name}" => invalid, }) }
            it 'should fail' do
              expect do
                should contain_class(subject)
              end.to raise_error(Puppet::Error, /#{var[:message]}/)
            end
          end
        end
      end # var[:name].each
    end # validations.sort.each
  end # describe 'variable type and content validations'
end
