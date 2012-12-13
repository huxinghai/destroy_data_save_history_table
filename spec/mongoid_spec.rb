require 'spec_helper'
require 'mongoid_data'

describe "destroy data save to history_table" do 
	before_for :each do 
		order = Order.new(
			:order_number => Time.now.strftime("%Y%m%d%H%M%S%L"), 
			:user_name => "kaka", 
			:supplier_name => "google"
		)
		order.save
		order_detail = OrderDetail.new(
			:product_name => "google cloud",
			:quantity => 1,
			:price => 500,
			:order_id => order.id
		)
	end
end