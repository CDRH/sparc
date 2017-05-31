require 'test_helper'

class FeaturesControllerTest < ActionController::TestCase
  setup do
    @feature = features(:one)
  end

  # test "should get index" do
  #   get :index
  #   assert_response :success
  #   assert_not_nil assigns(:features)
  # end

  # test "should get new" do
  #   get :new
  #   assert_response :success
  # end

  # test "should create feature" do
  #   assert_difference('Feature.count') do
  #     post :create, feature: { comments: @feature.comments, depth_mbd: @feature.depth_mbd, count: @feature.count, feature_form: @feature.feature_form, feature_group: @feature.feature_group, feature_no: @feature.feature_no, feature_type: @feature.feature_type, floor_association: @feature.floor_association, grid: @feature.grid, location_in_room: @feature.location_in_room, occupation: @feature.occupation, other_associated_features: @feature.other_associated_features, real_feature: @feature.real_feature, residential_feature: @feature.residential_feature, room: @feature.room, strat: @feature.strat }
  #   end

  #   assert_redirected_to feature_path(assigns(:feature))
  # end

  # test "should show feature" do
  #   get :show, id: @feature
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get :edit, id: @feature
  #   assert_response :success
  # end

  # test "should update feature" do
  #   patch :update, id: @feature, feature: { comments: @feature.comments, depth_mbd: @feature.depth_mbd, count: @feature.count, feature_form: @feature.feature_form, feature_group: @feature.feature_group, feature_no: @feature.feature_no, feature_type: @feature.feature_type, floor_association: @feature.floor_association, grid: @feature.grid, location_in_room: @feature.location_in_room, occupation: @feature.occupation, other_associated_features: @feature.other_associated_features, real_feature: @feature.real_feature, residential_feature: @feature.residential_feature, room: @feature.room, strat: @feature.strat }
  #   assert_redirected_to feature_path(assigns(:feature))
  # end

  # test "should destroy feature" do
  #   assert_difference('Feature.count', -1) do
  #     delete :destroy, id: @feature
  #   end

  #   assert_redirected_to features_path
  # end
end
