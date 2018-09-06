class AddUniquenessTagging < ActiveRecord::Migration[5.1]
  def change
    add_index :taggings, [:tag_id, :url_id], unique: true
  end
end
