require 'data_snapshots/engine'
require 'data_snapshots/configuration'

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
    snapshot = configuration.snapshots[name]

    Array(collection).each do |instance|
      data = {}
      snapshot[:methods].each do |name, method|
        data[name] = method.call(instance)
      end
      DataSnapshots::Snapshot.create(
        name: name,
        model_id: instance.id,
        model_type: instance.class.to_s,
        data: data
      )
    end
  end
end
