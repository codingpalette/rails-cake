class AddNicknameToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :nickname, :string

    # 기존 사용자들에게 닉네임 부여
    reversible do |dir|
      dir.up do
        User.reset_column_information
        User.find_each.with_index(1) do |user, index|
          user.update_column(:nickname, "cake-#{index}")
        end
      end
    end

    add_index :users, :nickname, unique: true
  end
end
