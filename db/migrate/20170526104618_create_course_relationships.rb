class CreateCourseRelationships < ActiveRecord::Migration[5.0]
  def change
    create_table :course_relationships do |t|
      t.belongs_to :product
      t.belongs_to :user

      t.timestamps
    end
  end
end
