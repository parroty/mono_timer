class CreateTimers < ActiveRecord::Migration
  def change
    create_table :timers do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.integer :status
      t.string :category
      t.string :description

      t.timestamps null: false
    end
  end
end
