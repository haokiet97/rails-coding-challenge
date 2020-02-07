class AddBusinessName < ActiveRecord::Migration
   def self.up
      add_column :contacts, :business_name, :string
   end

   def self.down
      remove_column :contacts, :business_name
   end
end
