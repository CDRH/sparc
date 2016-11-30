require 'test_helper'

class ExcavationStatusTest < ActiveSupport::TestCase
  def setup
    @item = ExcavationStatus.create(:excavation_status => "test")
    @item.units << Unit.first
  end

  test "associations" do
    # check generally that these respond with collections, not nil, etc
    assert_not_empty @item.units
  end
end
