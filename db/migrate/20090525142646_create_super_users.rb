class CreateSuperUsers < ActiveRecord::Migration
  def self.up
    create_table :super_users do |t|
      t.string :login
      t.string :email
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token
      t.integer :login_count
      t.datetime :last_request_at
      t.datetime :last_login_at
      t.datetime :current_login_at
      t.string :last_login_ip
      t.string :current_login_ip

      t.timestamps
    end
    add_index :super_users, :email
    add_index :super_users, :login
  end

  def self.down
    drop_table :super_users
  end
end
