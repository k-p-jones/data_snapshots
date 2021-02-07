# frozen_string_literal: true

require 'test_helper'

class ActiveRecordExtensionTest < ActiveSupport::TestCase
  def setup
    User.create(name: 'Bob', age: 23)

    DataSnapshots.configure do |c|
      c.register_snapshot name: :users_age do |methods|
        methods[:current_age] = ->(r) { r.age }
      end

      c.register_snapshot name: :users_name do |methods|
        methods[:current_name] = ->(r) { r.name }
      end
    end

    DataSnapshots.generate_snapshots(name: :users_age, collection: User.all)
    DataSnapshots.generate_snapshots(name: :users_name, collection: User.all)
  end

  test '#<name>_snapshots' do
    user = User.last
    assert_equal 1, user.users_age_snapshots.count
    assert_equal 1, user.users_name_snapshots.count

    snap_1 = user.users_age_snapshots.first
    snap_2 = user.users_name_snapshots.first

    assert_equal 23, snap_1.data['current_age']
    assert_equal 'Bob', snap_2.data['current_name'] 
  end

  test '#generate_snapshot' do
    user = User.last

    assert_difference 'DataSnapshots::Snapshot.count', 1 do
      user.generate_snapshot(name: :users_name)
    end

    assert_equal 2, user.users_name_snapshots.count

    # passing the name of a snapshot that hasn't been registered
    assert_equal false, user.generate_snapshot(name: :unregistered)

    assert_difference 'DataSnapshots::Snapshot.count', 0 do
      user.generate_snapshot(name: :unregistered)
    end
  end
end
