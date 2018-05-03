// On page load
$(function () {
  // Enable Bootstrap popovers
  $('[data-toggle="popover"]').popover();

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
})
