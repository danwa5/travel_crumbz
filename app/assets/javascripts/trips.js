$(document).ready(function() {

  $("#add-location-button").click(function() {
    var index = $("#locations").find($('input[name$="[address]"]')).length;

    var newFormGroup = $(document.createElement('div')).attr("class", 'form-group');
    var htmlFormGroup = '<label class="col-sm-3 control-label" for="trip_locations_attributes_' + index + '_address">Location</label>'
      + '<div class="col-sm-7"><input class="form-control new-location" value="" type="text" name="trip[locations_attributes][' + index + '][address]" id="trip_locations_attributes_' + index + '_address" placeholder="Where did you go?"/></div>'
      + '<div class="col-sm-1"><input class="form-control location-order" value="' + (index+1) + '" type="text" name="trip[locations_attributes][' + index + '][order]" id="trip_locations_attributes_' + index + '_order"/></div>';
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

  $(document).on('change', '.form-group .col-sm-1 .location-order', function(evt) {
    var num = $(this).val();
    $(this).parent().parent().insertBefore($('.form-group:nth-child('+num+')'));
    $('.form-group .col-sm-1 .location-order').each(function (i, input) {
      $(input).val(i + 1);
    });
  });

});
