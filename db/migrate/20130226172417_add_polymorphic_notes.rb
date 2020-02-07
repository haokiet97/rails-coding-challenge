class AddPolymorphicNotes < ActiveRecord::Migration
   def up
      add_column :notes, :subject_id, :integer
      add_column :notes, :subject_type, :string
   end

   def down
      remove_column :notes, :subject_id
      remove_column :notes, :subject_type
   end
end
