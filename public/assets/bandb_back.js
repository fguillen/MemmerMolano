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