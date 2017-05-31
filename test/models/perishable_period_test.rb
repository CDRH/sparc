require 'test_helper'

class PerishablePeriodTest < ActiveSupport::TestCase
  def setup
    @item = PerishablePeriod.create(:name => "test")
    @item.perishables << Perishable.first
  end

  test "associations" do
    # check generally that these respond with collections, not nil, etc
    assert_not_empty @item.perishables
  end
end
