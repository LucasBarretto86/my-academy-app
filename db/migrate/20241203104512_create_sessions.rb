class CreateSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :sessions do |t|
      t.string :user_agent, default: ""
      t.string :ip_address, default: ""
      t.string :token, default: "", null: false, index: true
      t.datetime :logged_at, default: "", null: false
      t.datetime :expires_at, default: "", null: false
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps null: false
    end

    add_index :sessions, [:user_id, :expires_at]
  end
end
