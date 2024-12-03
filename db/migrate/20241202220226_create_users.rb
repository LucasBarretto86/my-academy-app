class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name, null: false, default: ""
      t.string :surname, null: false, default: ""
      t.string :email, null: false, index: { unique: true }
      t.string :password_digest, null: false, default: ""
      t.boolean :admin, null: false, default: false

      t.timestamps null: false
    end
  end
end
