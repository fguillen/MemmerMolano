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

function ajaxify( form_element ){

}