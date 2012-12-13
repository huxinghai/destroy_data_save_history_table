
module History
    module Data
        extend ActiveSupport::Concern

        module ClassMethods
            def has_history_destroy_condition(&block)  
                if block_given?              
                    @_block = block 
                else
                    puts "error : not class block!"
                end
            end

            def history_table_name(name = nil)
                @name = name unless name.nil?
                @name
            end

            def get_history_condition
                @_block
            end
        end

        def __histories
            __history_model.find(self.id) rescue nil
        end

        def destroy(*args)
            if super *args  
                if filter_condition
                    model = __history_model.new(self.attributes)
                    model.id = self.attributes["_id"] if self.attributes.key?("_id")
                    model.save
                end
                true
            else
                false
            end            
        end

        private 
        def filter_condition
            model = Kernel.const_get(self.class.name)
            model.get_history_condition.nil? ? true : model.get_history_condition.call(self)
        end

        def history_collection_name
            model = Kernel.const_get(self.class.name)                 
            model.history_table_name || "history_#{self.collection_name.to_s}"            
        end

        def __history_model            
            if @__histories.nil?                
                @__histories = HistroyTable.clone                
                @__histories.store_in collection: history_collection_name
                clone_model_field(@__histories)             
            end            
            @__histories
        end

        def clone_model_field(model)
            self.fields.each do | k,v |       
                options = {
                    :type => v.type
                }         
                options[:pre_processed] = false if k == "_id"                
                model.field k, options
            end
        end
    end
end