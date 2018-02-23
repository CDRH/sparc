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

$(document).ready(map_setup);
