class AddNoteActivityType < ActiveRecord::Migration
   def up
      add_column :notes, :activity_type, :string
   end

   def down
      remove_column :notes, :activity_type
   end
end
