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
  // 菜单自动打开
  $('.dropdown').hover(function() {
      $(this).addClass('open');
    },
    function() {
      $(this).removeClass('open');
    });

  /*商品数量输入控制*/
  $('#quantity-input').on('input', function(event) {
    var max = parseToInt($('.product-quantity').html());
    var num = parseToInt($(this).val());
    if (num <= 1) {
      $(this).val('1');
      $("#quantity-minus").addClass('disabled');
    } else {
      $("#quantity-minus").removeClass('disabled');
    }
    // 限制输入数量不大于库存
    if (num >= max) {
      $(this).val(max);
      $("#quantity-plus").addClass('disabled');
    } else {
      $(this).val(num);
      $("#quantity-plus").removeClass('disabled');
    }
  }).on('blur', function(event) {
    var value = $(this).val();
    if (value == '' || value == '0') {
      $(this).val('1');
    }
  });

  /*增加数量*/
  $("#quantity-plus").click(function(event) {
    event.preventDefault();
    var max = parseToInt($('.product-quantity').html());
    var num = parseInt($("#quantity-input").val()) + 1;
    $("#quantity-minus").removeClass("disabled");
    if (num >= max) {
      $("#quantity-input").val(max);
      $(this).addClass('disabled');
    } else {
      $("#quantity-input").val(num);
    }
  });

  /*减少数量*/
  $("#quantity-minus").click(function(event) {
    event.preventDefault();
    var num = parseInt($("#quantity-input").val());
    if (num > 1) {
      $("#quantity-input").val(num -= 1);
      $("#quantity-plus").removeClass("disabled");
    }
    if (num <= 1) {
      $("#quantity-minus").addClass("disabled");
    }
  });

  /*购物车全选*/
  $(".cart-select-all").change(function(e) {
    cartSelectAll(this.checked);
  });

  /*监听购物车物品选择*/
  listenCartItemSelections();
});

// 内容转为数字
function parseToInt(value) {
  while (value.match(/[^\d]/)) {
    value = value.replace(/[^\d]/, '');
  }
  return parseInt(value == '' ? 0 : value);
}

// 全选购物车商品
function cartSelectAll(checked) {
  $("#cart-select-all-top").prop("checked", checked);
  $("#cart-select-all-bottom").prop("checked", checked);
  var cartItemsCount = parseInt($("#cart-items-count").val());
  for (i = 0; i < cartItemsCount; i++) {
    $("#cart-item-select-" + i).prop("checked", checked);
  }
  // 更新选中商品数量
  $("#items-count").html(checked ? cartItemsCount : 0);
  // 重新计算总价
  calculateTotalPrice();
}

// 监听购物车物品选择
function listenCartItemSelections() {
  var cartItemsCount = parseInt($("#cart-items-count").val());
  for (i = 0; i < cartItemsCount; i++) {
    new cartItemSelectionListener(i);
  }
}

// 购物车物品选择监听器
function cartItemSelectionListener(index) {
  var index = index;
  var cartItemsCount = parseInt($("#cart-items-count").val());
  $("#cart-item-select-" + index).change(function(e){
    var selectedCount = 0;
    for (i = 0; i < cartItemsCount; i ++){
      if ($("#cart-item-select-" + i).is(":checked")) selectedCount++;
    }
    // 商品全部被勾选
    if (cartItemsCount == selectedCount) {
      $("#cart-select-all-top").prop("checked", true);
      $("#cart-select-all-bottom").prop("checked", true);
    } else {
      $("#cart-select-all-top").prop("checked", false);
      $("#cart-select-all-bottom").prop("checked", false);
    }
    // 更新选中商品数量
    $("#items-count").html(selectedCount);
    // 重新计算总价
    calculateTotalPrice();
  });
}

// 计算总价
function calculateTotalPrice() {
  var totalPrice = 0.0;
  var cartItemsCount = parseInt($("#cart-items-count").val());
  for (i = 0; i < cartItemsCount; i ++){
    if ($("#cart-item-select-" + i).is(":checked")) {
      totalPrice += parseFloat($("#cart-item-subtotal-" + i).html());
    }
  }
  $("#total-price").html(totalPrice.toFixed(2));
}
