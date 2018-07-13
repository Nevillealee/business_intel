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

class Charge < ActiveRecord::Base
  self.primary_key = :charge_id
  self.table_name = 'charges'
end

class ChargeShippingLine < ActiveRecord::Base
  self.table_name = 'charges_shipping_lines'
  belongs_to :charge
end

class ChargeShippingAddress < ActiveRecord::Base
  self.table_name = 'charges_shipping_address'
  belongs_to :charge
end

class ChargeFixedLineItems < ActiveRecord::Base
  belongs_to :subscription
  belongs_to :charge
end

class RechargeCustomer < ActiveRecord::Base
  self.table_name = 'customers'
  self.primary_key = :customer_id
  has_many :subscriptions
  has_many :orders, through: :subscriptions
  has_many :charges
end
