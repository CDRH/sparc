require 'test_helper'

class StratTypeTest < ActiveSupport::TestCase
  def setup
    @item = StratType.create(:code => "test")
    @item.strata << Stratum.first
  end

  test "associations" do
    # check generally that these respond with collections, not nil, etc
    assert_not_empty @item.strata
  end
end
