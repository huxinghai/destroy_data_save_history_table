require 'mongoid'

Mongoid.load!(File.expand_path("../../config/mongoid.yml", __FILE__), :test)

class Order
    include Mongoid::Document
    include Mongoid::Timestamps

    field :order_number, :type => String
    field :user_name, :type => String
    field :supplier_name, :type => String

    has_many :details, :class_name => :OrderDetail, :dependent => :destroy
end


class OrderDetail
    include Mongoid::Document
    include Mongoid::Timestamps

    field :product_name, :type => String
    field :store_name, :type => String
    field :quantity, :type => Float
    field :price, :type => Float

    belongs_to :Order
end