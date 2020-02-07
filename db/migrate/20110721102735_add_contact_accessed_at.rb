class AddContactAccessedAt < ActiveRecord::Migration
   def self.up
      add_column :contacts, :accessed_at, :datetime
   end

   def self.down
      remove_column :contacts, :accessed_at
   end
end
