# DestroyDataSaveHistoryTable

将删除的数据保存到历史表
 
## Installation

Add this line to your application's Gemfile:

    gem 'destroy_data_save_history_table', :github => "huxinghai1988/destroy_data_save_history_table"

And then execute:

    $ bundle

## Usage
    
模型包含:

    class Order 
        include Mongoid::Document
        include Mongoid::Timestamps
        ## 该模型删除数据时保存到历史表
        include History::Data

    end


过滤条件:    
    
    ## 设置条件 订单name等于kaka的不会记录到历史表
    has_history_destroy_condition do | order |
        order.name != "kaka"
    end

设置历史表名: 

    ## 设置条件 订单name等于kaka的不会记录到历史表
    history_table_name("history_table_name")

设置历史数据名:

    history_database_name("history_database_name")

获取历史数据模型:
    
    Order.__history_model
