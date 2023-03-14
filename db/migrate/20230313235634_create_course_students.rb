class CreateCourseStudents < ActiveRecord::Migration[6.1]
  def change
    create_table :course_students do |t|

      t.timestamps
    end
  end
end
