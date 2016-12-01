require 'test_helper'

class ImageQualityTest < ActiveSupport::TestCase
  def setup
    @item = ImageQuality.first
    @item.images << Image.first
  end

  test "associations" do
    assert_not_empty @item.images
  end

end
