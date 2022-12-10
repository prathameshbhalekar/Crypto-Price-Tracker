class CreateAlerts < ActiveRecord::Migration[7.0]
  def change
    create_table :alerts do |t|
      t.float :trigger
      t.float :init_price
      t.boolean :is_active
      t.string :symbol

      t.timestamps
    end
  end
end
