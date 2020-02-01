class AddUniqueIndexToPackages < ActiveRecord::Migration[6.0]
  def change
  	add_index :packages, [:package_name, :version], unique: true
  end
end
