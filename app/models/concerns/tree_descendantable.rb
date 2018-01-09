module TreeDescendantable
  extend ActiveSupport::Concern

  DEFAULT_TREE_DEPTH = 10

  included do
    class_attribute :tree_depth, instance_accessor: false
    class_attribute :tree_primary_key, :path_column
    self.tree_primary_key ||= :id
    self.path_column = :path

    scope :self_and_descendant_entities, -> (entity, column: nil) do
      column ||= path_column
      _value = entity.send(column)

      where("(#{self.table_name}.#{column} like ? or #{self.table_name}.#{column} = '#{_value}')", "#{_value}/%")
    end

    scope :exclude_self_and_descendant_entities, -> (entity, column: nil) do
      column ||= path_column

      where("(#{self.table_name}.#{column} not like ? or #{self.table_name}.#{column} IS NULL)", "#{entity.send(column)}%")
    end

    scope :descendant_entities, -> (entity, column: nil) do
      column ||= path_column

      where("(#{self.table_name}.#{column} like ?)", "#{entity.send(column)}\/%")
    end

    scope :with_tree_depth, -> (tree_depth = 1, operator: , column: nil) do
      column ||= path_column

      where("#{tree_depth_calcul_sql(column: column)} #{operator} ?", tree_depth)
    end

    scope :order_by_tree_depth, -> (sort = "asc", column: nil) do
      column ||= path_column

      order(%Q{tree_depth_calcul_sql(column: column) #{sort}})
    end

    before_update :clean_descendant_cache, if: :path_changed?

    self.tree_depth = DEFAULT_TREE_DEPTH
  end

  def self_and_descendant_entities
    self.class.self_and_descendant_entities(self)
  end

  def descendant_entities
    self.class.descendant_entities(self)
  end

  def children
    _tree_depth = tree_depth + 1

    descendant_entities.with_tree_depth(
      _tree_depth, operator: "="
    )
  end

  def indirectly_descendant_entities
    _tree_depth = tree_depth + 2

    descendant_entities.with_tree_depth(
      _tree_depth, operator: ">="
    )
  end
  alias :indirectly_descendants :indirectly_descendant_entities

  def descendant_entity_ids
    @descendant_entity_ids ||= self_and_descendant_entity_ids.reject{|_id|
      _id == id
    }
  end

  def self_and_descendant_entity_ids
    @self_and_descendant_entity_ids ||= -> {
      _value = Rails.cache.fetch(self_and_descendant_entity_ids_cache_key, raw: true, expires_in: 1.hours) do
        self_and_descendant_entities.pluck(tree_primary_key).to_yaml
      end

      _value.present? ? YAML.load(_value) : self_and_descendant_entities.pluck(tree_primary_key)
    }.call
  end

  def ancestor_entities
    return self.class.none if path.blank?

    self.class.where(tree_primary_key => ancestor_entity_ids)
  end

  def ancestor_entity_ids
    _ids = self_and_ancestor_entity_ids
    _ids.reject!{|_id| _id.eql? "#{id}"}
  end

  def self_and_ancestor_entity_ids
    _ids = send(path_column).split("/")
    _ids.reject!{|_id| _id.eql? "0"}
  end

  def self_and_ancestor_entities
    return self.class.none if send(path_column).blank?

    self.class.where(tree_primary_key => self_and_ancestor_entity_ids)
  end

  # ============ update path_column
  def tree_depth
    if self.send(path_column).blank?
      return 1
    end

    self.send(path_column).count('/')
  end

  def exceed_max_depth?
    tree_depth > self.class.tree_depth
  end

  def update_path
    _path = generate_tree_path

    if self.send(path_column) != _path
      @old_descendant_entity_ids = descendant_entities.pluck(tree_primary_key) if send(path_column).present?

      self.update_columns(path: _path)

      clean_descendant_cache
    end

    if @old_descendant_entity_ids.present?
      self.class.where(tree_primary_key => @old_descendant_entity_ids).find_each{|u| u.update_path }
    end
  end

  def clean_descendant_cache
    self_and_ancestor_entities.each {|entity|
      _key = entity.self_and_descendant_entity_ids_cache_key

      Rails.cache.delete(_key) if _key.present?
    }
  end

  def generate_tree_path
    paths = [self.send(tree_primary_key)]
    _parent = self.parent
    self.class.tree_depth.times do
      break if _parent.nil?
      _parent_id = _parent.send(tree_primary_key)
      paths << _parent.send(tree_primary_key) unless paths.include?(_parent_id)
      _parent = _parent.parent
    end

    _path = paths.reverse.unshift(0).join('/')
  end

  def self_and_descendant_entity_ids_cache_key
    @self_and_descendant_entity_ids_cache_key ||= "self_and_descendant_ids:#{self.class.name.underscore}:#{id}:" << Digest::SHA1.hexdigest("#{path}")
  end

  module ClassMethods
    def tree_depth_as(depth)
      self.tree_depth = depth

      after_save :update_path
    end

    def tree_depth_calcul_sql(column: )
      <<~EOF
        ROUND(
          (
            LENGTH(`#{column}`) - LENGTH(REPLACE(`#{column}`, '/', ''))
          ) / LENGTH('/')
        )
      EOF
    end
  end
end
