# frozen_string_literal: true

require 'test_helper'

class GenerateSnapshotsTest < ActiveSupport::TestCase
  def setup
    DataSnapshots.configure do |c|
      c.register_snapshot name: :users do |methods|
        methods[:current_name] = ->(r) { r.name }
        methods[:current_age] = ->(r) { r.age }
      end
    end
  end

  test 'it generates snapshots for the given collection' do
    steve = User.create(name: 'Steve', age: 31)
    alice = User.create(name: 'Alice', age: 28)

    assert_difference 'DataSnapshots::Snapshot.count', 2 do
      DataSnapshots.generate_snapshots(name: :users, collection: User.all)
    end

    steves_snapshots = DataSnapshots::Snapshot.where(model_id: steve.id, model_type: 'User', name: 'users')
    alices_snapshots = DataSnapshots::Snapshot.where(model_id: alice.id, model_type: 'User', name: 'users')

    assert_equal 1, steves_snapshots.count
    assert_equal 1, alices_snapshots.count

    assert_equal 'Steve', steves_snapshots.first.data['current_name']
    assert_equal 31, steves_snapshots.first.data['current_age']

    assert_equal 'Alice', alices_snapshots.first.data['current_name']
    assert_equal 28, alices_snapshots.first.data['current_age']
  end
end
