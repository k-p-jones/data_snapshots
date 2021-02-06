require 'test_helper'

class SnapshotTest < ActiveSupport::TestCase
  test 'it is valid with a name and data' do
    snap = data_snapshots_snapshots(:valid)
    assert snap.valid?
  end

  test 'it is invalid without a name' do
    snap = data_snapshots_snapshots(:no_name)
    refute snap.valid?
  end

  test 'it is invalid without data' do
    snap = data_snapshots_snapshots(:no_data)
    refute snap.valid?
  end
end
