class CreateCourseLessons < ActiveRecord::Migration[7.1]
  def change
    create_table :course_lessons do |t|
      t.integer :number, null: false
      t.string :title, null: false, default: ""
      t.text :description, null: false, default: ""
      t.belongs_to :course, null: false, foreign_key: true

      t.timestamps null: false
    end

    add_index :course_lessons, [:course_id, :number], unique: true
  end
end
