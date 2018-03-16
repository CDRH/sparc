var map_setup = function() {
  var map = svgPanZoom('#map_combined', {
    zoomEnabled: true,
    controlIconsEnabled: true,
    fit: true,
    center: true,
  });
  // set default zoom for map
  map.zoom(1.8);
};

$(document).ready(map_setup);

document.getElementById('toggle_salmon_occ').checked = true;
document.getElementById('toggle_trenches').checked = true;

function toggle_trenches_display(e) {
  if (e.checked) { document.getElementById('trenches').style.display = 'block'; }
  if (!e.checked) { document.getElementById('trenches').style.display = 'none'; }
}

function toggle_salmon_display() {
  document.getElementById('salmon_occ').style.display = 'block';
  document.getElementById('chaco_occ').style.display = 'none';
}

function toggle_chaco_display() {
  document.getElementById('salmon_occ').style.display = 'none';
  document.getElementById('chaco_occ').style.display = 'block';
}
