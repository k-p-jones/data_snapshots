require 'test_helper'

class SnapshotTest < ActiveSupport::TestCase
  test 'it is valid with a name and data' do
    snap = DataSnapshots::Snapshot.new(name: 'users', data: { name: 'Bob' })
    assert snap.valid?
  end

  test 'it is invalid without a name' do
    snap = DataSnapshots::Snapshot.new(data: { name: 'Bob' })
    refute snap.valid?
  end

  test 'it is invalid without data' do
    snap = DataSnapshots::Snapshot.new(name: 'users')
    refute snap.valid?
  end
end
