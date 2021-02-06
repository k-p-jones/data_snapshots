class IsolateSnapshotsNamespace < ActiveRecord::Migration[6.0]
  def change
    rename_table :snapshots, :data_snapshots_snapshots
  end
end
