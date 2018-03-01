require 'test_helper'

class DocumentTest < ActiveSupport::TestCase
  test "canonical_unit_no" do
    a = Document.create(image_upload: "TT12_RR_0016.jpeg")
    assert_equal "TT12", a.canonical_unit_no

    b = Document.create(image_upload: "130W_FRSA_0019.jpeg")
    assert_equal "130W", b.canonical_unit_no

    c = Document.create(image_upload: "212P_M_0002.jpeg")
    assert_equal "212P", c.canonical_unit_no
  end
end
