class AddAddressToForecast < ActiveRecord::Migration[7.1]
  def change
    add_column :forecasts, :address, :string
  end
end
