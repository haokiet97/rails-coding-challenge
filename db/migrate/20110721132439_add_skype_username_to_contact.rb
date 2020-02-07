class AddSkypeUsernameToContact < ActiveRecord::Migration
   def self.up
      add_column :contacts, :skype, :string
   end

   def self.down
      remove_column :contacts, :skype
   end
end
