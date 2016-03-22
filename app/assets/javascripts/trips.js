$(document).ready(function() {
  var index = $("#existing-locations").find($('input[type="text"]')).length;

  $("#addLocationButton").click(function() {
    index++;

    var newFormGroup = $(document.createElement('div')).attr("class", 'form-group');
    newFormGroup.after().html('<label class="col-sm-3 control-label" for="trip_locations_attributes_' + index + '_address">Location ' + index + '</label><div class="col-sm-8"><input class="form-control" type="text" name="trip[locations_attributes][' + index + '][address]" id="trip_locations_attributes_' + index + '_address" value="" placeholder="Where did you go?"/></div>');

    newFormGroup.appendTo("#existing-locations");
  });
});
