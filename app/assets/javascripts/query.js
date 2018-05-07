// On page load
$(function () {
  // =====================
  // Common Search Options
  // =====================

  // Enable Bootstrap popovers
  $('[data-toggle="popover"]').popover();

  var optionGroups =
    ['unitclass', 'unitnum', 'occupation', 'stratum', 'feature' ];

  // Update option group badge counts
  optionGroups.forEach(function(group) {
    groupCheckboxes = '#collapse-'+ group +' .checkbox';
    $(groupCheckboxes).each(function(index, checkbox) {
      $(checkbox).click(group, updateBadgeCount);
    });
  });

  // =====================
  // Table Search Options
  // =====================

  // Add collapse class on page load
  $("#query_table_description").addClass('collapse');
  $("#query_other_otions").addClass('collapse');

  // Change text on "show table description" button
  $("#query_desc_disp_btn").clicktoggle(
    function() {
      $(this).text("Hide table description");
    },
    function() {
      $(this).text("Show table description");
    }
  );

  // Change text on "show more search options"
  $("#query_search_options_btn").clicktoggle(
    function() {
      $(this).text("Hide more search options");
    },
    function() {
      $(this).text("Show more search options");
    }
  );
});

// ====================
// Function Definitions
// ====================

var updateBadgeCount = function(event) {
  group = event.data;

  checkboxes = '#collapse-'+ group +' .checkbox input:checked';
  count = $(checkboxes).length;

  badge = '#heading-'+ group +' .badge';
  $(badge).text(count);

  if (count > 0) {
    if ($(badge).hasClass("hidden")) {
      $(badge).removeClass("hidden");
      $(badge).attr("aria-hidden", false);
    }
  }
  else {
    $(badge).addClass("hidden");
    $(badge).attr("aria-hidden", true);
  }
};
