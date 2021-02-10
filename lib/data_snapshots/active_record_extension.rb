# frozen_string_literal: true

require 'active_support/concern'

module DataSnapshots
  module ActiveRecordExtension
    extend ActiveSupport::Concern

    def method_missing(method, *args, &block)
      return super(method, *args, &block) unless method.to_s.end_with?('_snapshots')
      match_data = method.to_s.match(/(?<snapshot_name>\w+)_snapshots/)
      name = match_data[:snapshot_name]
      fetch_snapshots(name)
    end

    def generate_snapshot(name:)
      snapshot = DataSnapshots.configuration.snapshots[name]

      unless snapshot
        raise UnregisteredSnapshotError.new("Snapshot: #{name} has not been registered")
      end

      data = {}
      snapshot[:methods].each do |name, method|
        data[name] = method.call(self)
      end

      DataSnapshots::Snapshot.create!(
        name: name,
        model_id: self.id,
        model_type: self.class.to_s,
        data: data
      )
    end

    private

    def fetch_snapshots(name)
      DataSnapshots::Snapshot.where(name: name)
                             .where(model_id: self.id)
                             .where(model_type: self.class.to_s)
                             .order(:created_at)      
    end
  end
end

ActiveRecord::Base.send(:include, DataSnapshots::ActiveRecordExtension)
