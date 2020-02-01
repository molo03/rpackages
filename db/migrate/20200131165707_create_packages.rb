class CreatePackages < ActiveRecord::Migration[6.0]
  def change
    create_table :packages do |t|
      t.string :package_name
      t.string :version
      t.datetime :publication_date
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
