class CreateJoinTable < ActiveRecord::Migration[6.0]
  def change
    create_join_table :packages, :contributors do |t|
    	t.string :role
      # t.index [:package_id, :contributor_id]
      # t.index [:contributor_id, :package_id]
    end
  end
end
