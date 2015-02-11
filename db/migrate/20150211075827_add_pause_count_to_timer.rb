class AddPauseCountToTimer < ActiveRecord::Migration
  def change
    add_column :timers, :pauses_count, :integer, null: false, default: 0
  end
end
