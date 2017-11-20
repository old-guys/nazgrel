module SesameMall::Source
  class Base < ActiveRecord::Base
    establish_connection SERVICES_CONFIG["sesame_mall_db"]
    self.abstract_class = true
  end
end
