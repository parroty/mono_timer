require "test_helper"

class PauseTest < ActiveSupport::TestCase

  def pause
    @pause ||= Pause.new
  end

  def test_valid
    assert pause.valid?
  end

end
