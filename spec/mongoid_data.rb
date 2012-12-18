require 'mongoid'

Mongoid.load!(File.expand_path("../../config/mongoid.yml", __FILE__), :test)

class Order
    include Mongoid::Document
    include Mongoid::Timestamps
    include History::Data

    field :order_number, :type => String
    field :user_name, :type => String
    field :supplier_name, :type => String

    has_many :details, :class_name => "OrderDetail", :dependent => :destroy

    def self.have?(id)
        find(id) rescue nil
    end

    after_destroy :notice_msg

    def notice_msg
        puts "success order ..."
    end
end


class OrderDetail
    include Mongoid::Document
    include Mongoid::Timestamps
    include History::Data

    field :product_name, :type => String
    field :store_name, :type => String
    field :quantity, :type => Float
    field :price, :type => Float

    belongs_to :Order

    validate :validate_order_exists?

    def validate_order_exists?        
        errors.add(:order_id, "order not exists !")  unless Order.have?(order_id)
    end
end