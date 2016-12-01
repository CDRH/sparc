require 'test_helper'

class ImageCreatorTest < ActiveSupport::TestCase
  def setup
    @item = ImageCreator.first
    @item.images << Image.first
  end

  test "associations" do
    assert_not_empty @item.images
  end

end
