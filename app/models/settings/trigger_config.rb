class TriggerConfig < ApplicationRecord
  enum source: {
    sesame_mall: 0
  }
end
