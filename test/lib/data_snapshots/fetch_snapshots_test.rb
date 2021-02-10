# frozen_string_literal: true

require 'test_helper'

class FetchSnapshotsTest < ActiveSupport::TestCase
  def setup
    User.create(name: 'Bob', age: 23)

    DataSnapshots.configure do |c|
      c.register_snapshot name: :oldest_user, model: false do |methods|
        methods[:current_oldest] = ->() { User.all.pluck(:age).max }
      end
    end

    DataSnapshots.generate_snapshot(name: :oldest_user)
    User.last.update(age: 37)
    DataSnapshots.generate_snapshot(name: :oldest_user)
  end

  test 'it fetches the correct snapshots' do
    snapshots = DataSnapshots.fetch_snapshots(name: :oldest_user)
    assert_equal 23, snapshots[0].data['current_oldest']
    assert_equal 37, snapshots[1].data['current_oldest']
  end
end
