# frozen_string_literal: true

class CreateGeolocations < ActiveRecord::Migration[7.1]
  def change
    create_table :geolocations do |t|
      t.string :ip
      t.string :country
      t.string :city
      t.decimal :latitude
      t.decimal :longitude
      t.string :provider

      t.timestamps
    end
  end
end
