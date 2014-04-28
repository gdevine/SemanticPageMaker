class AddFieldtypeToFields < ActiveRecord::Migration
  def change
    add_column :fields, :fieldtype, :string
  end
end
