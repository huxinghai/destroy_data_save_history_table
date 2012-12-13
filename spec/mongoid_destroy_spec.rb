require 'spec_helper'
require 'mongoid_data'

describe "destroy data save to history_table" do 

    def new_order
        Order.new(
            :order_number => Time.now.strftime("%Y%m%d%H%M%S%L"), 
            :user_name => "kaka", 
            :supplier_name => "google"
        )
    end

    def new_order_detail(order_id)
        OrderDetail.new(
            :product_name => "google cloud",
            :quantity => 1,
            :price => 500,
            :order_id => order_id
        )
    end

    def create_order
        order = new_order
        order.save
        order_detail = new_order_detail(order.id)
        order_detail.save
        [order, order_detail]
    end

    before :each do    
        Order.destroy_all
        @order, @order_detail= create_order
    end

    it "create order" do         
        @order.new_record?.should be_false
    end

    it "create order detail" do 
        @order_detail.new_record?.should be_false
    end

    it "destroy order data" do 
        @order.destroy
        _order = Order.find(@order.id) rescue nil
        _order.should be_nil
        OrderDetail.where(:order_id => @order.id).length.should eq(0)
    end

    it "destroy order deta test history" do
        order = new_order
        order.save.should be_true

        order_detail = new_order_detail(order.id)
        order_detail.save.should be_true

        order.destroy.should be_true
        order.__histories.should_not be_nil
        order.id.should eq(order.__histories.id)
        order.__histories.collection.name.should eq("history_#{order.collection.name}")
    end

    it "setting save history table name" do 
        order_table_name = "order_history_table"
        order_detail_table_name = "order_details_history_table"

        Order.class_eval do 
            history_table_name(order_table_name)
        end

        OrderDetail.class_eval do 
            history_table_name(order_detail_table_name)
        end

        order, order_detail = create_order
        order.destroy

        order.__histories.collection.name.should eq(order_table_name)
        order_detail.__histories.collection.name.should eq(order_detail_table_name)
    end

    it "filter condition save history" do 
        Order.class_eval do 
            has_history_destroy_condition do | _order |
                _order.user_name != "kaka"
            end
        end

        OrderDetail.class_eval do 
            has_history_destroy_condition do | detail |
                detail.product_name != "google cloud"
            end
        end

        order, order_detail = create_order
        order.destroy.should be_true
        order.__histories.should be_nil
        order_detail.__histories.should be_nil
    end
end