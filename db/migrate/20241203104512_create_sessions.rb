class CreateSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :sessions do |t|
      t.string :user_agent, default: ""
      t.string :ip_address, default: ""
      t.string :auth_token, default: "", null: false
      t.boolean :tos, default: false, null: false
      t.boolean :expired, default: false, null: false
      t.datetime :accessed_at, default: "", null: false
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps null: false
    end
  end
end
