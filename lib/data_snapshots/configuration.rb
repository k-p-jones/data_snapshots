# frozen_string_literal: true

module DataSnapshots
  class Configuration
    attr_reader :snapshots

    def initialize
      @snapshots = {}
    end

    def register_snapshot(name:, model: true)
      return unless block_given?
      snapshots[name] = { methods: {}, model: model }
      yield snapshots[name][:methods]
    end
  end
end
