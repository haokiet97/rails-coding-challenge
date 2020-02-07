class AddAddressDetails < ActiveRecord::Migration
   def self.up
      add_column :contacts, :street_address, :text
      add_column :contacts, :city, :string
      add_column :contacts, :state, :string
      add_column :contacts, :post_code, :string
      add_column :contacts, :country, :string
   end

   def self.down
      remove_column :contacts, :country
      remove_column :contacts, :post_code
      remove_column :contacts, :state
      remove_column :contacts, :city
      remove_column :contacts, :street_address
   end
end
