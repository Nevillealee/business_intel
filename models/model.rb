#model.rb
class Subscription < ActiveRecord::Base
    self.table_name = 'subscriptions'
    self.primary_key = :subscription_id
end

class SubLineItem < ActiveRecord::Base
    self.table_name = 'sub_line_items'
end

class SkipReason < ActiveRecord::Base
    self.table_name = 'skip_reasons'
end