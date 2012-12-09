$(function(){
  _.templateSettings = {
    interpolate : /\{\{([\s\S]+?)\}\}/g
  };

  $("#loading").ajaxStart( function() {
    console.log( "loading" );
    $(this).animate({ top: "0" }, 200);
  });

  $("#loading").ajaxStop( function() {
    console.log( "loading finish!" );
    $(this).animate({ top: "-70" }, 100);
  });

});

function niceFileField( file_field ){
  file_field.after("<div class=\"nice_file_field input-append\"><input class=\"input span4\" type=\"text\"><a class=\"btn\">Browse</a></div>");

  var nice_file_field = file_field.next(".nice_file_field");
  nice_file_field.find("a").click( function(){ file_field.click() });
  file_field.change( function(){
    nice_file_field.find("input").val(file_field.val());
  });
};

function ajaxify( form_element, errors_wrapper_element ){
  var parseResponse = function( data ){
    if( data.errors ) {
      errors_wrapper_element.append("<ul></ul>");
      _.each(data.errors, function( error ){
        errors_wrapper_element.find("ul").append( "<li>" + error + "</li>" );
      });
      errors_wrapper_element.fadeIn();

    } else {
      console.log( "Form sending success" );
    }
  };

  form_element.on( "submit", function( event ){
    event.preventDefault();

    errors_wrapper_element.hide();
    errors_wrapper_element.find("ul").remove();

    $.ajax({
      url: form_element.attr("action"),
      type: form_element.attr("method"),
      success: parseResponse,
      error: function( error ){ console.error( "error", error ) },
      data: form_element.serialize()
    });
  });
}