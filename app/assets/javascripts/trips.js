$(document).ready(function() {

  $("#add-location-button").click(function() {
    var index = $("#locations").find($('input[type="text"]')).length;
    index++;

    var newFormGroup = $(document.createElement('div')).attr("class", 'form-group');
    newFormGroup.after().html('<label class="col-sm-3 control-label" for="trip_locations_attributes_' + index + '_address">Location ' + index + '</label><div class="col-sm-8"><input class="form-control new-location" type="text" name="trip[locations_attributes][' + index + '][address]" id="trip_locations_attributes_' + index + '_address" value="" placeholder="Where did you go?"/></div>');

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

});
