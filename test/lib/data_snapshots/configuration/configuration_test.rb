# frozen_string_literal: true

class ConfigurationTest < ActiveSupport::TestCase
  test 'exposes the config data' do
    config = DataSnapshots::Configuration.new
    assert_equal config.snapshots, {}
  end

  test 'allows a model snapshot to be registered' do
    config = DataSnapshots::Configuration.new
    method = ->() {}
    config.register_snapshot name: :test_snapshot do |snapshot|
      snapshot[:test] = method
    end

    expected = { methods: { test: method }, model: true }

    assert_equal expected, config.snapshots[:test_snapshot]
  end

  test 'allows a generic snapshot to be registered' do
    config = DataSnapshots::Configuration.new
    method = ->() {}
    config.register_snapshot name: :test_snapshot, model: false do |snapshot|
      snapshot[:test] = method
    end

    expected = { methods: { test: method }, model: false }

    assert_equal expected, config.snapshots[:test_snapshot]
  end
end
