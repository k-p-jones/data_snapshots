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
    User.last.update(age: 31)
    DataSnapshots.generate_snapshots(name: :users_age, collection: User.all)

    DataSnapshots.generate_snapshots(name: :users_name, collection: User.all)
    User.last.update(name: 'Steve')
    DataSnapshots.generate_snapshots(name: :users_name, collection: User.all)
  end

  test '#<name>_snapshots' do
    user = User.last
    assert_equal 2, user.users_age_snapshots.count
    assert_equal 2, user.users_name_snapshots.count

    age_snaps = user.users_age_snapshots
    name_snaps = user.users_name_snapshots

    assert_equal 23, age_snaps[0].data['current_age']
    assert_equal 31, age_snaps[1].data['current_age']

    assert_equal 'Bob', name_snaps[0].data['current_name']
    assert_equal 'Steve', name_snaps[1].data['current_name']
  end

  test '#generate_snapshot' do
    user = User.last

    assert_difference 'DataSnapshots::Snapshot.count', 1 do
      user.generate_snapshot(name: :users_name)
    end

    assert_equal 3, user.users_name_snapshots.count

    # passing the name of a snapshot that hasn't been registered
    assert_raises UnregisteredSnapshotError do
      user.generate_snapshot(name: :unregistered)
    end
  end
end
