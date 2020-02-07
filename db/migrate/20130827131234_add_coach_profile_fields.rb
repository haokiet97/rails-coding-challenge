class AddCoachProfileFields < ActiveRecord::Migration
   def up
      add_column :contacts, :position, :text
      add_column :contacts, :credentials, :text
      add_column :contacts, :superpowers, :text
   end

   def down
      add_column :contacts, :position
      add_column :contacts, :credentials
      add_column :contacts, :superpowers
   end
end
