require 'test_helper'

class SalmonSectorTest < ActiveSupport::TestCase
  def setup
    @item = SalmonSector.create(:salmon_sector => "test")
    @item.units << Unit.first
  end

  test "associations" do
    # check generally that these respond with collections, not nil, etc
    assert_not_empty @item.units
  end
end
