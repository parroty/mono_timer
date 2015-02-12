require 'test_helper'

describe TimersController do
  before do
    Timer.all.delete_all
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

  it "creates timer and gets redirected to index page" do
    assert_difference 'Timer.count', 1, "A Timer should be created" do
      post :create
    end
    assert_redirected_to timers_path
  end

  it "stops timer and gets redirected to index page" do
    post :stop, id: @timer.id
    assert_redirected_to timers_path
  end

  it "resumes timer and gets redirected to index page" do
    post :resume, id: @timer.id
    assert_redirected_to timers_path
  end

  it "pauses timer and gets redirected to index page" do
    post :pause, id: @timer.id
    assert_redirected_to timers_path
  end

  it "deletes timer and gets redirected to history page" do
    assert_difference 'Timer.count', -1, "A Timer should be destroyed" do
      delete :destroy, id: @timer.id
    end
    assert_redirected_to timers_history_path
  end
end
