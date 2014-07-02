class RemoveAnswerFromEntries < ActiveRecord::Migration
  def change
    remove_column :entries, :answer, :string
  end
end
