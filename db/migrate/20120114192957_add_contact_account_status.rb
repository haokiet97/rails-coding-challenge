class AddContactAccountStatus < ActiveRecord::Migration
   def self.up
      add_column :contacts, :account_status, :string
   end

   def self.down
      remove_column :contacts, :account_status
   end
end
