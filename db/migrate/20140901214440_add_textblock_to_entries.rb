class AddTextblockToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :textblock, :text
  end
end
