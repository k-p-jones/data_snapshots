# frozen_string_literal: true

module DataSnapshots
  class Snapshot < ApplicationRecord
    validates :name, presence: true
    validates :data, presence: true
  end
end
