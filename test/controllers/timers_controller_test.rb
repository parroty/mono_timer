require "test_helper"

describe TimersController do
  before do
    @timer = FactoryGirl.create(:completed)
  end

  it "gets index" do
    get :index
    assert_response :success
    must_render_template :index
  end

  describe "create" do
    it "creates timer and gets redirected to index page" do
      assert_difference "Timer.count", 1, "A Timer should be created" do
        post :create
      end
      assert_redirected_to timers_path
    end

    it "fails to create timer if previous one is running" do
      FactoryGirl.create(:running)
      assert_difference "Timer.count", 0, "A Timer should not be created" do
        post :create
      end
      assert_not_equal nil, flash[:error]
    end
  end

  describe "show" do
    it "gets show page by html" do
      get :show, id: @timer.id
      assert_redirected_to timers_path
    end

    it "gets show page by json" do
      get :show, id: @timer.id, format: :json
      body = JSON.parse(response.body)
      assert_equal @timer.id, body["id"]
    end
  end

  it "gets timer history page" do
    get :history
    assert_response :success
    must_render_template :history
  end

  describe "operations" do
    before do
      @running_timer = FactoryGirl.create(:running)
      @paused_timer  = FactoryGirl.create(:paused)
    end

    describe "stop" do
      it "succeeds to stop paused timer" do
        post :stop, id: @paused_timer.id
        assert_nil flash[:error]
        assert_redirected_to timers_path
      end

      it "fails to stop running timer" do
        post :stop, id: @running_timer.id
        refute_nil flash[:error]
        assert_redirected_to timers_path
      end
    end

    describe "resume" do
      it "succeeds to resume paused timer" do
        post :resume, id: @paused_timer.id
        assert_nil flash[:error]
        assert_redirected_to timers_path
      end

      it "fails to resume running timer" do
        post :resume, id: @running_timer.id
        refute_nil flash[:error]
        assert_redirected_to timers_path
      end
    end

    describe "pause" do
      it "succeeds to pause running timer" do
        post :pause, id: @running_timer.id
        assert_nil flash[:error]
        assert_redirected_to timers_path
      end

      it "fails to pause paused timer" do
        post :pause, id: @paused_timer.id
        refute_nil flash[:error]
        assert_redirected_to timers_path
      end
    end
  end

  it "deletes timer and gets redirected to history page" do
    assert_difference "Timer.count", -1, "A Timer should be destroyed" do
      delete :destroy, id: @timer.id
    end
    assert_redirected_to timers_history_path
  end
end
