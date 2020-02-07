class AddContactLastNoteAt < ActiveRecord::Migration
   def up
      add_column :contacts, :last_note_at, :datetime
   end

   def down
      add_column :contacts, :last_note_at, :datetime
   end
end
