require 'data_snapshots/engine'
require 'data_snapshots/configuration'

class UnregisteredSnapshotError < StandardError
end

class IncompatibleSnapshotError < StandardError
end

module DataSnapshots
  class << self
    attr_accessor :configuration
  end

  def self.table_name_prefix
    'data_snapshots_'
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  def self.generate_snapshots(name:, collection:)
    Array(collection).each do |instance|
      instance.generate_snapshot(name: name)
    end
  end

  def self.generate_snapshot(name:)
    snapshot = DataSnapshots.configuration.snapshots[name]

    unless snapshot
      raise UnregisteredSnapshotError.new("Snapshot: #{name} has not been registered")
    end

    if snapshot[:model]
      raise IncompatibleSnapshotError.new(
        "Snapshot: #{name} is a model snapshot, this method is for generic snapshots." \
        "Try calling #generate_snapshot(name: #{name}) on an instance of the appropriate model." \
        "Alternatively, call DataSnapshots.generate_snapshots(name: #{name}, collection: [Array of instances])"
      )
    end

    data = {}
    snapshot[:methods].each do |key, method|
      data[key] = method.call()
    end

    DataSnapshots::Snapshot.create!(name: name, data: data)
  end

  def self.fetch_snapshots(name:)
    DataSnapshots::Snapshot.where(name: name).order(:created_at)
  end
end
