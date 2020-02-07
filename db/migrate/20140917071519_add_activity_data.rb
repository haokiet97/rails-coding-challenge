class AddActivityData < ActiveRecord::Migration
  def up
    add_column :notes, :data, :text
  end

  def down
    remove_column :notes, :data
  end
end
