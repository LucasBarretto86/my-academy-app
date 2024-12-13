class AddColumnsDurationToCourseLessons < ActiveRecord::Migration[7.1]
  def change
    add_column :course_lessons, :duration, :float, default: 0.0
  end
end
