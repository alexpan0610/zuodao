class ChangeIsAdminToRoleType < ActiveRecord::Migration[5.0]
  def up
    add_column :users, :role_type, :integer, default: 0
    User.all.each do |user|
      user.update_attribute("role_type", user.is_admin ? 31 : 0)
    end
    remove_column :users, :is_admin
  end

  def down
    add_column :users, :is_admin, :boolean, default: false
    User.all.each do |user|
      user.update_attribute("is_admin", user.role_type == 31)
    end
    remove_column :users, :role_type
  end
end
