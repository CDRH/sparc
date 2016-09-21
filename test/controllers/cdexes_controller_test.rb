require 'test_helper'

class CodexesControllerTest < ActionController::TestCase
  setup do
    @codex = codexes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:codexes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create codex" do
    assert_difference('Codex.count') do
      post :create, codex: { context: @codex.context, period: @codex.period, room: @codex.room, room_id: @codex.room_id, strat_alpha: @codex.strat_alpha, strat_one: @codex.strat_one, strat_two: @codex.strat_two }
    end

    assert_redirected_to codex_path(assigns(:codex))
  end

  test "should show codex" do
    get :show, id: @codex
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @codex
    assert_response :success
  end

  test "should update codex" do
    patch :update, id: @codex, codex: { context: @codex.context, period: @codex.period, room: @codex.room, room_id: @codex.room_id, strat_alpha: @codex.strat_alpha, strat_one: @codex.strat_one, strat_two: @codex.strat_two }
    assert_redirected_to codex_path(assigns(:codex))
  end

  test "should destroy codex" do
    assert_difference('Codex.count', -1) do
      delete :destroy, id: @codex
    end

    assert_redirected_to codexes_path
  end
end
