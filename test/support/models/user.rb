require 'active_record'

class CreateUsersTables < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :role, :default => 'user'

      t.timestamps
    end
  end
end

CreateUsersTables.migrate(:up)

class User < ActiveRecord::Base
  validates  :first_name, :last_name, presence: true,  length: {:within => 2..100}
  validates  :email, presence: true, uniqueness: true,  length: {:maximum => 100}

  attr_accessible :email, :first_name, :last_name
end
