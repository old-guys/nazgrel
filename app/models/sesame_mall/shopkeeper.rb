class Shopkeeper < ApplicationRecord
  include TreeDescendantable
  self.tree_depth = 100
  self.tree_primary_key = :user_id
  belongs_to :shop, required: false

  belongs_to :parent, primary_key: :user_id,
    foreign_key: :invite_user_id,
    class_name: :Shopkeeper, required: false

  has_many :income_records, foreign_key: :user_id

  def to_s
    name || id.to_s
  end
end
