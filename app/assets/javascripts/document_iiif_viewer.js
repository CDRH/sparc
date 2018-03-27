var getUrlParameter = function getUrlParameter(sParam) {
  var sPageURL = decodeURIComponent(window.location.search.substring(1)),
      sURLVariables = sPageURL.split('&'),
      sParameterName,
      i;

  for (i = 0; i < sURLVariables.length; i++) {
    sParameterName = sURLVariables[i].split('=');
    if (sParameterName[0] === sParam) {
      return sParameterName[1] === undefined ? true : sParameterName[1];
    }
  }
};

function loadManifests(manifests, cb) {
  console.log('load menu manifests');
  if ((getUrlParameter('manifests') != null) && (getUrlParameter('manifests') != 'undefined')) {
    manifests = getUrlParameter('manifests');
  }
  var manifestsUri = manifests;
  console.log(manifestsUri);
  // load manifests
  $.getJSON(manifestsUri, function(manifests){
    console.log('loaded menu manifests')
    var $manifestSelect = $('#manifestSelect');
    for (var i = 0; i < manifests.collections.length; i++) {
      var collection = manifests.collections[i];
      if (collection.visible === false) continue;
        for (var j = 0; j < collection.manifests.length; j++){
          var manifest = collection.manifests[j];
          if (manifest.visible !== false){
            $manifestSelect.append('<option value="' + manifest['@id'] + '">' + manifest.label + '</option>');
          }
        }
        $manifestSelect.append('</optgroup>');
      }
    cb();
  });
}

function reload() {
  var manifest = $('#manifest').val();
  var locale = $('#locales').val() || 'en-GB';

  // clear hash params
  clearHashParams();

  var qs = document.location.search.replace('?', '');
  qs = Utils.Urls.updateURIKeyValuePair(qs, 'manifest', manifest);
  qs = Utils.Urls.updateURIKeyValuePair(qs, 'locale', locale);

  if (window.location.search === '?' + qs){
      window.location.reload();
  } else {
      window.location.search = qs;
  }
}

function clearHashParams(){
    document.location.hash = '';
}

function setSelectedManifest(){
  var manifest = Utils.Urls.getQuerystringParameter('manifest');

  if (manifest) {
      $('#manifestSelect').val(manifest);
  } else {
    var options = $('#manifestSelect option');
    if (options.length){
      manifest = options[0].value;
    }
  }
  $('#manifest').val(manifest);
  $('.uv').attr('data-uri', manifest);
}

function init() {
  $('#manifestSelect').on('change', function(){
    $('#manifest').val($('#manifestSelect option:selected').val());
    reload();
  });
  $('#manifest').click(function() {
    $(this).select();
  });
  $('#manifest').keypress(function(e) {
    if(e.which === 13) {
      reload();
    }
  });
  $('#setManifestBtn').on('click', function(e){
    e.preventDefault();
    reload();
  });
  if ($('#manifestSelect option').length || $('#manifestSelect optgroup').length){
    setSelectedManifest();
  }
  // setInitialLocale();
}
