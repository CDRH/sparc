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

// require_tree .


// =======================
// Common jQuery Functions
// =======================

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
