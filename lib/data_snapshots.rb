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
    Array(collection).each do |instance|
      instance.generate_snapshot(name: name)
    end
  end
end
