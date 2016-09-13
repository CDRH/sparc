require 'test_helper'

class RoomsControllerTest < ActionController::TestCase
  setup do
    @room = rooms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rooms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create room" do
    assert_difference('Room.count') do
      post :create, room: { comments: @room.comments, excavated_status: @room.excavated_status, floor_area_text: @room.floor_area_text, inferred_function: @room.inferred_function, intact_roof: @room.intact_roof, irregular_shape: @room.irregular_shape, length_text: @room.length_text, occupation: @room.occupation, other_desc: @room.other_desc, room_class: @room.room_class, room_no: @room.room_no, room_type_id: @room.room_type_id, salmon_sector: @room.salmon_sector, stories: @room.stories, type_description: @room.type_description, width_text: @room.width_text }
    end

    assert_redirected_to room_path(assigns(:room))
  end

  test "should show room" do
    get :show, id: @room
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @room
    assert_response :success
  end

  test "should update room" do
    patch :update, id: @room, room: { comments: @room.comments, excavated_status: @room.excavated_status, floor_area_text: @room.floor_area_text, inferred_function: @room.inferred_function, intact_roof: @room.intact_roof, irregular_shape: @room.irregular_shape, length_text: @room.length_text, occupation: @room.occupation, other_desc: @room.other_desc, room_class: @room.room_class, room_no: @room.room_no, room_type_id: @room.room_type_id, salmon_sector: @room.salmon_sector, stories: @room.stories, type_description: @room.type_description, width_text: @room.width_text }
    assert_redirected_to room_path(assigns(:room))
  end

  test "should destroy room" do
    assert_difference('Room.count', -1) do
      delete :destroy, id: @room
    end

    assert_redirected_to rooms_path
  end
end
