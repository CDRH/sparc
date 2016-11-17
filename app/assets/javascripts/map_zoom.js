var map_setup = function() {
  // Expose to window namespase for testing purposes
  window.zoomTiger = svgPanZoom('#map_zoom', {
    zoomEnabled: true,
    controlIconsEnabled: true,
    fit: true,
    center: true,
    // viewportSelector: document.getElementById('demo-tiger').querySelector('#g4') // this option will make library to misbehave. Viewport should have no transform attribute
  });
};

// ready / load recommendations from http://stackoverflow.com/a/35246512/4154134
$(document).ready(map_setup);
$(document).on('page:load', map_setup)
$(document).on('turbolinks:load', map_setup)
