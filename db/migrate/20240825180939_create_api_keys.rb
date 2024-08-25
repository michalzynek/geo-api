# frozen_string_literal: true

class CreateAPIKeys < ActiveRecord::Migration[7.1]
  def change
    create_table :api_keys do |t|
      t.string :token

      t.timestamps
    end

    add_index :api_keys, :token, unique: true
  end
end
