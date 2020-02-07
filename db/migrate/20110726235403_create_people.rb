class CreatePeople < ActiveRecord::Migration
  def self.up
    rename_table :contacts, :people
    add_column :people, :type, :string
  end

  def self.down
    remove_column :people, :type
    rename_table :people, :contacts
  end
end
