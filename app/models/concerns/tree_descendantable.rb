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

      where("(#{self.table_name}.#{path_column} like ? or #{self.table_name}.#{path_column} = '#{_value}')", "#{_value}/%")
    end

    scope :exclude_self_and_descendant_entities, -> (entity, column: nil) do
      column ||= path_column

      where("(#{self.table_name}.#{path_column} not like ? or #{self.table_name}.#{path_column} IS NULL)", "#{entity.path}%")
    end

    scope :descendant_entities, -> (entity, column: nil) do
      column ||= path_column

      where("(#{self.table_name}.#{path_column} like ?)", "#{entity.path}\/%")
    end

    scope :with_tree_depth, -> (tree_depth = 1, column: nil) do
      return none if tree_depth > self.tree_depth
      column ||= path_column

      tree_depth_calcul_sql = %Q{ROUND ( (LENGTH(#{path_column}) - LENGTH(REPLACE(#{path_column}, '/', ''))) / LENGTH('/') )}
      where("(#{tree_depth_calcul_sql}) = ?", tree_depth)
    end

    scope :self_and_descendant_entities_by_tree_depth, -> (tree_depth, column: nil) do
      return none if tree_depth > self.tree_depth
      column ||= path_column

      tree_depth_calcul_sql = %Q{ROUND ( (LENGTH(#{path_column}) - LENGTH(REPLACE(#{path_column}, '/', ''))) / LENGTH('/') )}
      where("(#{tree_depth_calcul_sql}) >= ?", tree_depth)
    end

    scope :exclude_self_and_descendant_entities_by_tree_depth, -> (tree_depth, column: nil) do
      return none if tree_depth.to_i > self.tree_depth.to_i
      column ||= path_column

      tree_depth_calcul_sql = %Q{ROUND ( (LENGTH(#{path_column}) - LENGTH(REPLACE(#{path_column}, '/', ''))) / LENGTH('/') )}
      where.not("(#{tree_depth_calcul_sql}) >= ?", tree_depth)
    end

    scope :self_and_ancestor_entities_by_tree_depth, ->(tree_depth, column: nil) do
      return none if tree_depth > self.tree_depth
      column ||= path_column

      tree_depth_calcul_sql = %Q{ROUND ( (LENGTH(#{path_column}) - LENGTH(REPLACE(#{path_column}, '/', ''))) / LENGTH('/') )}
      where("(#{tree_depth_calcul_sql}) <= ?", tree_depth)
    end

    scope :order_by_tree_depth, -> (sort = "asc", column: nil) do
      column ||= path_column

      order(%Q{ROUND((LENGTH(#{path_column}) - LENGTH(REPLACE(#{path_column}, '/', ''))) / LENGTH('/')) #{sort}})
    end

    before_update :clean_descendant_cache, if: :path_changed?

    self.tree_depth = DEFAULT_TREE_DEPTH
  end

  def should_update_path?
    _parent_key = self.class.reflect_on_association(:parent).foreign_key

    send("#{_parent_key}_changed?")
  end

  def descendant_entities
    self.class.descendant_entities(self)
  end

  def children
    entities_by_tree_depth(tree_depth + 1, self)
  end

  def descendant_entity_ids
    @descendant_entity_ids ||= self_and_descendant_entity_ids.reject{|_id|
      _id == id
    }
  end

  def self_and_descendant_entities
    self.class.self_and_descendant_entities(self)
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

  def ancestor_entity_on(depth: )
    _ids = self_and_ancestor_entity_ids
    _index = depth - 1

    self.class.find_by(tree_primary_key => _ids[_index]) if _index >= 0 and _ids[_index].present?
  end

  def self_and_ancestor_entity_ids
    _ids = path.split("/")
    _ids.reject!{|_id| _id.eql? "0"}
  end

  def self_and_ancestor_entities
    return self.class.none if path.blank?

    self.class.where(tree_primary_key => self_and_ancestor_entity_ids)
  end

  def parent_and_descendant_entities
    return self.class.none if self.parent.blank?

    self.class.self_and_descendant_entities(self.parent)
  end

  def descendant_of_parent_entities
    return self.class.none if self.parent.blank?

    self.class.descendant_entities(self.parent)
  end

  def self_and_descendant_and_sibling_descendant_entities
    if self.root? && self.path.present?
      self_and_descendant_entities
    else
      #self.class.find_by_sql self_and_descendant_and_sibling_descendant_sql
      self.class.where(%Q{id in (#{self_and_descendant_and_sibling_descendant_sql})})
    end
  end

  def entities_by_tree_depth(tree_depth, root = nil)
    _root = root.nil? ? self.root : root
    return self.class.none if _root.nil?

    tree_depth = tree_depth + _root.tree_depth - 1

    self.class.with_tree_depth(tree_depth).where("(#{self.class.table_name}.path like ?)", "#{_root.path}%")
  end

  def self_and_descendant_entities_by_tree_depth(tree_depth, root = nil)
    _root = root.nil? ? self.root : root
    return self.class.none if _root.nil?

    tree_depth = tree_depth + _root.tree_depth - 1

    self.class.self_and_descendant_entities_by_tree_depth(tree_depth).where("(#{self.class.table_name}.path like ?)", "#{_root.path}%")
  end

  def self_and_ancestor_entities_by_tree_depth(tree_depth, root = nil)
    _root = root.nil? ? self.root : root
    return self.class.none if _root.nil?

    tree_depth = tree_depth + _root.tree_depth - 1

    self.class.self_and_ancestor_entities_by_tree_depth(tree_depth).where("(#{self.class.table_name}.path like ?)", "#{_root.path}%")
  end

  def tree_depth
    if self.path.blank?
      return 1
    end

    self.path.count('/')
  end

  def exceed_max_depth?
    tree_depth > self.class.tree_depth
  end

  def can_add_child?(parent)
    return false if parent.blank?

    if self.new_record?
      return parent.tree_depth < self.class.tree_depth
    end

    if parent.tree_depth >= self.class.tree_depth
      return false
    end

    parent_depth = parent.tree_depth
    remain_depth = self.class.tree_depth - parent_depth

    return false if remain_depth <= 0

    check_depth = self.class.tree_depth - parent_depth + 1

    return false if self_and_descendant_entities_by_tree_depth(check_depth, self).take

    true
  end

  def update_path
    _path = generate_tree_path

    if self.path != _path
      @old_descendant_entity_ids = descendant_entities.pluck(tree_primary_key) if path.present?

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

  def self_and_descendant_and_sibling_descendant_sql
    return '' if self.root?
    _sql = []

    self.self_and_siblings.select(tree_primary_key, :path).find_each do |entity|
      if entity == self
        _sql.push self.class.where("(#{self.class.table_name}.path like ?)", "#{entity.path}%").select(tree_primary_key).to_sql
      else
        _sql.push self.class.where("(#{self.class.table_name}.path like ?)", "#{entity.path}\/%").select(tree_primary_key).to_sql
      end
    end

    _sql = _sql.join(" union ")
  end

  def generate_tree_path
    paths = [self.send(:tree_primary_key)]
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
  end
end
