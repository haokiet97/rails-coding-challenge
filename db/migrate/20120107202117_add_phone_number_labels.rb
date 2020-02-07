class AddPhoneNumberLabels < ActiveRecord::Migration
   def self.up
      add_column :contacts, :phone_1_label, :string
      add_column :contacts, :phone_2_label, :string
      add_column :contacts, :phone_3_label, :string
   end

   def self.down
      remove_column :contacts, :phone_3_label
      remove_column :contacts, :phone_2_label
      remove_column :contacts, :phone_1_label
   end
end
