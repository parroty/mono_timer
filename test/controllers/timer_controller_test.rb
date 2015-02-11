require 'test_helper'

describe TimerController do
  before do
    @timer = Timer.create!(start_time: Time.zone.now, category: "Programming")
  end

  it "gets index" do
    get :index
    assert_response :success
    must_render_template :index
  end

  it "gets timer history page" do
    get :history
    assert_response :success
    must_render_template :history
  end

  it "gets new timer page" do
    get :new
    assert_response :success
    must_render_template :new
  end

  it "creates timer and gets redirected to index page" do
    assert_difference 'Timer.count', 1, "A Timer should be created" do
      post :create
    end
    assert_redirected_to timer_index_path
  end

  it "deletes timer and gets redirected to history page" do
    assert_difference 'Timer.count', -1, "A Timer should be destroyed" do
      delete :destroy, id: @timer.id
    end
    assert_redirected_to timer_history_path
  end

  it "stops timer and gets redirected to index page" do
    assert_difference 'Timer.active.count', -1, "An active timer should be removed" do
      post :stop, id: @timer.id
    end
    assert_redirected_to timer_index_path
  end
end
