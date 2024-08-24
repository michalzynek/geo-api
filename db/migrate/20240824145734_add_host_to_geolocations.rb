# frozen_string_literal: true

class AddHostToGeolocations < ActiveRecord::Migration[7.1]
  def change
    add_column :geolocations, :host, :string
    add_index :geolocations, %i[ip host], unique: true
  end
end
