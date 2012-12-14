
module History
    module Data
        extend ActiveSupport::Concern

        # included do | klass |
        #     klass.
        # end

        module ClassMethods
            def has_history_destroy_condition(&block)  
                if block_given?              
                    @_block = block 
                else
                    puts "error : not class block!"
                end
            end

            def history_table_name(name = nil)
                @__table_name = name unless name.nil?
                @__table_name
            end

            def history_database_name(name = nil)
                @__database_name = name unless name.nil?
                @__database_name
            end

            def get_history_condition
                @_block
            end

            def __history_model            
                if @__histories.nil? || 
                    @__histories.collection_name != get_history_table_name || 
                    @__histories.collection.database.name != get_history_database_name   

                    @__histories = HistroyTable.clone                
                    @__histories.store_in collection: get_history_table_name, database: get_history_database_name
                    clone_model_field(@__histories)             
                end            
                @__histories
            end

            private
            def get_history_table_name
                history_table_name || "history_#{self.collection_name}"
            end

            def get_history_database_name
                history_database_name || self.collection.database.name
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

        def __histories
            __model.__history_model.find(self.id) rescue nil
        end

        def destroy(*args)
            if super *args  
                if filter_condition
                    model = __model.__history_model.new(self.attributes)
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
            __model.get_history_condition.nil? ? true : __model.get_history_condition.call(self)
        end

        def __model
            Kernel.const_get(self.class.name)
        end
    end
end