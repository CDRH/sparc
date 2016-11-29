require 'test_helper'

class InferredFunctionTest < ActiveSupport::TestCase
  def setup
    @item = InferredFunction.create(:inferred_function => "test")
    @item.units << Unit.first
  end

  test "associations" do
    # check generally that these respond with collections, not nil, etc
    assert_not_empty @item.units
  end
end
