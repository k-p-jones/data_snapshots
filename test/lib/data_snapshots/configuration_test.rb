# frozen_string_literal: true

class ConfigurationTest < ActiveSupport::TestCase
  test 'exposes the config data' do
    config = DataSnapshots::Configuration.new
    assert_equal config.snapshots, {}
  end

  test 'allows a snapshot to be registered' do
    config = DataSnapshots::Configuration.new
    method = ->() {}
    config.register_snapshot name: :test_snapshot do |snapshot|
      snapshot[:test] = method
    end
    assert_equal config.snapshots[:test_snapshot], { methods: { test: method } }
  end
end
