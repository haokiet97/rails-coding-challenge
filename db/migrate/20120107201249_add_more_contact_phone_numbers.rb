class AddMoreContactPhoneNumbers < ActiveRecord::Migration
   def self.up
      rename_column :contacts, :phone, :phone_1
      add_column :contacts, :phone_2, :string
      add_column :contacts, :phone_3, :string
   end

   def self.down
      remove_column :contacts, :phone_3
      remove_column :contacts, :phone_2
      rename_column :contacts, :phone_1, :phone
   end
end
