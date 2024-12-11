class CreateCourses < ActiveRecord::Migration[7.1]
  def change
    create_table :courses do |t|
      t.string :title, null: false, default: ""
      t.text :description, null: false, default: ""
      t.timestamp :begins_at, null: false
      t.timestamp :ends_at

      t.timestamps null: false
    end
  end
end
