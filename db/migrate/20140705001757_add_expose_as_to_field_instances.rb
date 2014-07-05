class AddExposeAsToFieldInstances < ActiveRecord::Migration
  def change
    add_column :field_instances, :exposeAs, :string
  end
end
