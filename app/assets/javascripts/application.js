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
//= require jquery_ujs
//= require bootstrap
//= require bootstrap-datepicker
//= require bootstrap-tagsinput
//= require atv-img-animation
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

  // 监听进度区是否可见
  listenVisibilityOfProgresses();

  /*商品数量输入控制*/
  $('#quantity-input').on('input', function(e) {
    var max = parseInt($(this).attr('max'));
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
    // 当用户输入0或空白时，将数量设为1
    var value = $(this).val();
    if (value == '' || value == '0') {
      $(this).val('1');
    }
  });

  /*增加数量*/
  $("#quantity-plus").click(function(e) {
    var max = parseInt($("#quantity-input").attr('max'));
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

// 收起通知信息
function slideUpAlert() {
  // 消息停留2000毫秒（2秒），消失动画时间250毫秒
  $(".alert").delay(2000).slideUp(250, function() {
    $(this).remove();
  });
}

// 监听进度区是否可见
function listenVisibilityOfProgresses() {
  var eventFired = false;
  $(window).scroll(function() {
    var offset = $('#progresses').offset();
    if (offset != null) {
      var hT = offset.top,
        hH = $('#progresses').outerHeight(),
        wH = $(window).height(),
        wS = $(this).scrollTop();
      if (!eventFired && wS > (hT + hH - wH)) {
        // 当进度条可见时，播放动画
        $('[data-toggle="tooltip"]').tooltip({
          trigger: 'manual'
        }).tooltip('show');

        $(".progress-bar").each(function() {
          each_bar_width = $(this).attr('aria-valuenow');
          $(this).width(each_bar_width + '%');
        });
        eventFired = true;
      }
    }
  });
}

// 将用户输入的内容转为数字
function parseToInt(value) {
  // 去掉用户输入的所有非数字字符
  while (value.match(/[^\d]/)) {
    value = value.replace(/[^\d]/, '');
  }
  // 将剩下的合法内容转为数字
  return parseInt(value == '' ? 0 : value);
}

// 初始化购物车物品选中状态
function setSelections(item_ids) {
  var cartItemsCount = parseInt($("#cart-items-count").val());
  if (cartItemsCount > 0 && item_ids.length == cartItemsCount) {
    // 所有课程都被选中
    cartSelectAll(true);
  } else {
    var count = 0;
    for (i = 0; i < cartItemsCount; i++) {
      var item = $("#cart-item-select-" + i);
      var checked = $.inArray(item.val(), item_ids) > -1;
      item.prop("checked", checked);
      if (checked) count++;
    }
    // 禁用/启用 删除选中课程按钮
    disableDeleteAllButton(count == 0);
  }
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
