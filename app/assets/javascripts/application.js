// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require bootstrap
//= require turbolinks
//= require_tree .
//= require turbolinks

$(document).on('turbolinks:load', function() {
  $('.dropdown').hover(function() {
      $(this).addClass('open');
  },
  function() {
      $(this).removeClass('open');
  });
});


/*增加数量*/
function increase_quantity(){
  event.preventDefault();
	var num = parseInt($(".quantity-input").val()) + 1;
	$(".quantity-input").val(num);
  if(num > 1){
    $("#quantity-minus").removeClass("disabled");
  }
}

/*减少数量*/
function decrease_quantity(){
  event.preventDefault();
	var num = parseInt($(".quantity-input").val());
	if(num > 1){
    $(".quantity-input").val(num -= 1);
	}
  if(num <= 1){
    $("#quantity-minus").addClass("disabled");
  }
}
