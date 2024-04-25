class CreateForecasts < ActiveRecord::Migration[7.1]
  def change
    create_table :forecasts do |t|
      t.string :location
      t.string :temperature
      t.datetime   :last_refreshed
      t.timestamps
    end
  end
end
