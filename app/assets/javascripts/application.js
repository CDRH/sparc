// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require lightbox_activation.js

// require_tree .



// Toggle function
$.fn.clicktoggle = function(a, b) {
  return this.each(function() {
    var clicked = false;
    $(this).bind("click", function() {
      if (clicked) {
        clicked = false;
        return b.apply(this, arguments);
      } else {
        clicked = true;
        return a.apply(this, arguments);
      }
    });
  });
};

// ===========
// Query Pages (needs click toggle above)
// ===========

$(function() {
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

  // change text on "show more search options"
  $("#query_search_options_btn").clicktoggle(
    function() {
      $(this).text("Hide more search options");
    },
    function() {
      $(this).text("Show more search options");
    }
  );

});
