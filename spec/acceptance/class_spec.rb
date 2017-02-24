require 'spec_helper_acceptance'

describe 'gitolite class' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
      include ::gitolite
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_failures => true)
    end
  end
end
