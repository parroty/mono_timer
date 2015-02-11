class AddTimerRefToPauses < ActiveRecord::Migration
  def change
    add_reference :pauses, :timer, index: true
    add_foreign_key :pauses, :timers
  end
end
