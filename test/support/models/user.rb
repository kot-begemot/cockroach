require 'active_record'

class CreateUsersTables < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.integer :writer_id

      t.timestamps
    end
  end
end

CreateUsersTables.migrate(:up)

class User < ActiveRecord::Base
  attr_accessible :writer_id
end
