require 'test_helper'

class EggshellAffiliationTest < ActiveSupport::TestCase
  def setup
    @item = EggshellAffiliation.create(:affiliation => "test")
    @item.eggshells << Eggshell.first
  end

  test "associations" do
    # check generally that these respond with collections, not nil, etc
    assert_not_empty @item.eggshells
  end
end
