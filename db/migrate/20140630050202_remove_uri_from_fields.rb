class RemoveUriFromFields < ActiveRecord::Migration
  def change
    remove_column :fields, :uri, :string
  end
end