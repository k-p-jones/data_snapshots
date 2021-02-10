# frozen_string_literal: true

require 'test_helper'

class GenerateSnapshotTest < ActiveSupport::TestCase
  def setup
    DataSnapshots.configure do |c|
      c.register_snapshot name: :users, model: false do |methods|
        methods[:current_count] = ->() { User.count }
        methods[:current_oldest] = ->() { User.all.pluck(:age).max }
      end

      c.register_snapshot name: :users_data do |methods|
        methods[:current_name] = ->(r) { r.name }
        methods[:current_age] = ->(r) { r.age }
      end
    end
  end

  test 'it generates the requested snapshot' do
    User.create(name: 'Steve', age: 31)
    User.create(name: 'Alice', age: 28)

    assert_difference 'DataSnapshots::Snapshot.count', 1 do
      DataSnapshots.generate_snapshot(name: :users)
    end

    snapshot = DataSnapshots::Snapshot.last

    assert_equal 2, snapshot.data['current_count']
    assert_equal 31, snapshot.data['current_oldest']
  end

  test 'it raises an error when called with a model snapshot' do
    assert_raises IncompatibleSnapshotError do
      DataSnapshots.generate_snapshot(name: :users_data)
    end    
  end

  test 'it raises an error when called with an unregistered snapshot' do
    assert_raises UnregisteredSnapshotError do
      DataSnapshots.generate_snapshot(name: :unregistered)
    end
  end
end
