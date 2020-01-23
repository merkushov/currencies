class CreateCurrencies < ActiveRecord::Migration[6.0]
  def change
    create_table :currencies do |t|
      t.string :code, limit: 5, null: false
      t.string :name, limit: 100, null: false
      t.decimal :rate, { default: 0.0000 }
      t.date :measure_date, null: false, default: -> { 'DATE(NOW())' }

      t.timestamps
      t.index [:code, :measure_date], unique: true
    end
  end
end
