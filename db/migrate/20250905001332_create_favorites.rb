class CreateFavorites < ActiveRecord::Migration[8.0]
  def change
    create_table :favorites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :bakery, null: false, foreign_key: true

      t.timestamps
    end
    
    # 한 사용자가 같은 베이커리를 중복 즐겨찾기하지 못하도록 유니크 인덱스 추가
    add_index :favorites, [:user_id, :bakery_id], unique: true
  end
end
