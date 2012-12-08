$(function() {
  $('.nivo_slider_performance').nivoSlider({
    effect: "fade",
    manualAdvance: true,
    animSpeed: 300
  });

  extras_links();
});


function extras_links(){
  $("#extras_elements ul li").each( function(index, element){
    console.log( "element", element );
    img_element = $(element).find("img");

    img_element.after("<div class=\"extra_title\">" + img_element.attr("title") + "</div>");
  });
}