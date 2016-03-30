$(document).ready(function() {

  $("#add-location-button").click(function() {
    var index = $("#locations").find($('input[name$="[address]"]')).length;

    var newFormGroup = $(document.createElement('div')).attr("class", 'form-group');
    var htmlFormGroup = '<label class="col-sm-3 control-label" for="trip_locations_attributes_' + index + '_address">Location</label>'
      + '<div class="col-sm-8"><div class="input-group"><span class="input-group-addon">'
      + '<input class="location-order" size="4" value="' + (index+1) + '" type="text" name="trip[locations_attributes][' + index + '][order]" id="trip_locations_attributes_' + index + '_order" data-toggle="tooltip" data-placement="top" data-original-title="Select and edit the order of location in the trip" />'
      + '</span><input class="form-control new-location" value="" type="text" name="trip[locations_attributes][' + index + '][address]" id="trip_locations_attributes_' + index + '_address" placeholder="Where did you go?"/></div></div>';
    newFormGroup.after().html(htmlFormGroup);

    newFormGroup.appendTo("#locations");
  });

  $(".new-trip").submit(function() {
    removeBlankLocations();
  });

  $(".edit-trip").submit(function() {
    removeBlankLocations();
  });

  function removeBlankLocations() {
    $(".new-location").each(function() {
      if ($.trim($(this).val()) === '') {
        $(this).closest('.form-group').remove();
      }
    });
  }

  // re-order trip locations
  $(document).on('change', '.location-order', function(evt) {
    var num = $(this).val();
    $(this).parent().parent().parent().parent().insertBefore( $('#locations .form-group:eq(' + (num-1) + ')') );
    $('.location-order').each(function(i, input) {
      $(input).val(i+1);
    });
  });

  // initialize jquery tooltip
  $(function() {
    $('[data-toggle="tooltip"]').tooltip()
  });

  // disable form submit upon ENTER keypress
  $("form").on("keypress", function(e) {
    if (e.keyCode == 13) {
      return false;
    }
  });
});
