module SesameMall::Source
  class Base < ActiveRecord::Base
    establish_connection SERVICES_CONFIG["sesame_mall_db"]
    self.abstract_class = true

    # java db do not use Single table inheritance
    self.inheritance_column = :_type_disabled
  end
end
