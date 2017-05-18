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
//= require bootstrap-datepicker
//= require material-kit
//= require material.min
//= require nouislider.min
//= require turbolinks
//= require_tree .

$(document).on('turbolinks:load', function() {
  // 菜单自动打开
  $('.dropdown').hover(function() {
      $(this).addClass('open');
    },
    function() {
      $(this).removeClass('open');
    });

  // 收起通知
  slideUpAlert();

  //for progress-bar
  $('[data-toggle="tooltip"]').tooltip({
    trigger: 'manual'
  }).tooltip('show');

  // $( window ).scroll(function() {
  // if($( window ).scrollTop() > 10){  // scroll down abit and get the action
  $(".progress-bar").each(function() {
    each_bar_width = $(this).attr('aria-valuenow');
    $(this).width(each_bar_width + '%');
  });

  /*商品数量输入控制*/
  $('#quantity-input').on('input', function(e) {
    var max = parseToInt($('#product-quantity').html());
    var num = parseToInt($(this).val());
    if (num <= 1) {
      $(this).val('1');
      $("#quantity-minus").addClass('disabled');
    } else {
      $("#quantity-minus").removeClass('disabled');
    }
    // 限制输入数量不大于名额
    if (num >= max) {
      $(this).val(max);
      $("#quantity-plus").addClass('disabled');
    } else {
      $(this).val(num);
      $("#quantity-plus").removeClass('disabled');
    }
  }).on('blur', function(e) {
    var value = $(this).val();
    if (value == '' || value == '0') {
      $(this).val('1');
    }
  });

  /*增加数量*/
  $("#quantity-plus").click(function(e) {
    var max = parseToInt($('#product-quantity').html());
    var num = parseInt($("#quantity-input").val()) + 1;
    $("#quantity-minus").removeClass("disabled");
    if (num >= max) {
      $("#quantity-input").val(max);
      $(this).addClass('disabled');
    } else {
      $("#quantity-input").val(num);
    }
    e.preventDefault();
  });

  /*减少数量*/
  $("#quantity-minus").click(function(e) {
    var num = parseInt($("#quantity-input").val());
    if (num > 1) {
      $("#quantity-input").val(num -= 1);
      $("#quantity-plus").removeClass("disabled");
    }
    if (num <= 1) {
      $("#quantity-minus").addClass("disabled");
    }
    e.preventDefault();
  });

  /*监听购物车勾选框*/
  listenCartItemsSelections();

  /*监听结算地址选择*/
  listenCheckoutAddressSelection();

  /*监听支付选项*/
  listenPaymentMethodSelection();

  // 加载日期选择器
  $('.datepicker').datepicker();
});

// 内容转为数字
function parseToInt(value) {
  while (value.match(/[^\d]/)) {
    value = value.replace(/[^\d]/, '');
  }
  return parseInt(value == '' ? 0 : value);
}

// 初始化购物车物品选中状态
function setSelections(selections) {
  var cartItemsCount = parseInt($("#cart-items-count").val());
  var count = 0;
  for (i = 0; i < cartItemsCount; i++) {
    var checked = $.inArray($("#cart-item-select-" + i).val(), selections) > -1;
    $("#cart-item-select-" + i).prop("checked", checked);
    if (checked) count++;
  }
  // 禁用/启用 删除选中课程按钮
  disableDeleteAllButton(count == 0);
}

// 全选购物车课程
function cartSelectAll(checked) {
  $(".cart-select-all").prop("checked", checked);
  var cartItemsCount = parseInt($("#cart-items-count").val());
  for (i = 0; i < cartItemsCount; i++) {
    $("#cart-item-select-" + i).prop("checked", checked);
  }
  // 更新选中课程数量
  $("#items-count").html(checked ? cartItemsCount : 0);
  // 禁用/启用 删除选中课程按钮
  disableDeleteAllButton(!checked);
  // 重新计算总价
  calculateTotalPrice();
}

// 监听购物车勾选框
function listenCartItemsSelections() {
  /*监听全选按钮*/
  $(".cart-select-all").change(function(e) {
    cartSelectAll(this.checked);
  });
  // 监听每个课程勾选
  var total = parseInt($("#cart-items-count").val());
  for (i = 0; i < total; i++) {
    new cartItemSelectionListener(total, i);
  }
  // 禁用删除选中课程按钮
  disableDeleteAllButton(true);
}

// 购物车物品选择监听器
function cartItemSelectionListener(total, index) {
  var index = index;
  $("#cart-item-select-" + index).change(function(e) {
    var count = 0;
    for (i = 0; i < total; i++) {
      if ($("#cart-item-select-" + i).is(":checked")) count++;
    }
    // 课程全部被勾选
    $(".cart-select-all").prop("checked", total == count);
    // 更新选中课程数量
    $("#items-count").html(count);
    // 禁用/启用 删除选中课程按钮
    disableDeleteAllButton(count == 0);
    // 重新计算总价
    calculateTotalPrice();
  });
}

// 禁用删除选中课程按钮
function disableDeleteAllButton(disable) {
  if (disable) {
    $(".cart-btn-delete-all-fake").addClass("disabled");
  } else {
    $(".cart-btn-delete-all-fake").removeClass("disabled");
  }
}

// 计算总价
function calculateTotalPrice() {
  var totalPrice = 0.0;
  var cartItemsCount = parseInt($("#cart-items-count").val());
  for (i = 0; i < cartItemsCount; i++) {
    if ($("#cart-item-select-" + i).is(":checked")) {
      totalPrice += parseFloat($("#cart-item-subtotal-" + i).html());
    }
  }
  $("#total-price").html(totalPrice.toFixed(2));
}

// 监听结算收货地址选择
function listenCheckoutAddressSelection() {
  var addressesCount = parseInt($("#addresses-count").val());
  for (i = 0; i < addressesCount; i++) {
    new addressSelectionListener(addressesCount, i);
  }
}

// 地址选择监听器
function addressSelectionListener(total, index) {
  var index = index;
  $("#address-" + index).click(function(e) {
    var selected = $("#address-id-" + index).val();
    for (i = 0; i < total; i++) {
      // 所有地址设为未选中
      setSelected($("#address-" + i), false);
      // 给设为默认按钮夹带参数
      var btnSetDefault = $("#checkout-btn-set-default-" + i);
      var href = btnSetDefault.attr("href");
      href = href.substring(0, href.indexOf("set_default")) + "set_default?selected=" + selected;
      btnSetDefault.attr("href", href);
    }
    // 设置被选中地址
    $("#selected-address").val(selected);
    // 将点击的地址设为选中
    setSelected($(this), true);
    e.preventDefault();
  });
}

// 支付选项监听
function listenPaymentMethodSelection() {
  var wechat = $(".wechat");
  var alipay = $(".alipay");
  wechat.click(function(e) {
    setSelected(wechat, true);
    setSelected(alipay, false);
    $("#payment-method").val("wechat");
  });
  alipay.click(function(e) {
    setSelected(alipay, true);
    setSelected(wechat, false);
    $("#payment-method").val("alipay");
  });
}

// 改变按钮选中状态
function setSelected(button, selected) {
  button.addClass(selected ? "btn-danger" : "btn-white");
  button.removeClass(selected ? "btn-white" : "btn-danger");
}

// 确认删除
function confirmDelete(path, message) {
  var dialog = $("#confirm-dialog");
  dialog.find(".btn-confirm").attr("href", path);
  if (message !== undefined) {
    dialog.find(".modal-body").html(message);
  }
}

// 移除购物车课程
function confirmRemoveCartItem(id, message) {
  var dialog = $("#confirm-dialog");
  if (message !== undefined) {
    dialog.find(".modal-body").html(message);
  }
  dialog.find(".btn-confirm").click(function() {
    $("#cart-btn-delete-" + id).click();
  });
}

// 移除购物车中选中的课程
function confirmRemoveCartItems() {
  var dialog = $("#confirm-dialog");
  dialog.find(".modal-body").html("确定移除选中的课程？");
  dialog.find(".btn-confirm").click(function() {
    $("#cart-btn-delete-all").click();
  });
}

// 收起通知信息
function slideUpAlert() {
  $(".alert").delay(2000).slideUp(250, function() {
    $(this).remove();
  });
}
