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
    li_element = $(element);
    img_element = $(element).find("img");

    li_element.append("<div class=\"extra_title\">" + img_element.attr("title") + "</div>");
  });
}