class Admins < ActiveRecord::Migration
  def change
    add_column :users, :is_admin, :boolean, default: false
    User.update_all(is_admin: false)

    add_column :subphezes, :is_admin_only, :boolean, default: false
    Subphez.update_all(is_admin_only: false)
  end
end
