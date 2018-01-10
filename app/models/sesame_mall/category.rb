class Category < ApplicationRecord
  include TreeDescendantable
  tree_depth_as 20

  belongs_to :parent, primary_key: :id,
    foreign_key: :parent_id,
    class_name: :Category, required: false

  include Searchable

  simple_search_on fields: [
    :name
  ]
end
