module FlashesHelper
  FLASH_CLASSES = { alert: "danger", notice: "success", info: "info", warning: "warning" }.freeze

  def flash_class(key)
    FLASH_CLASSES.fetch key.to_sym, key
  end

  def user_facing_flashes
    flash.to_hash.slice "alert", "notice", "info", "warning"
  end

  def render_alert_icon(key)
    case flash_class(key)
    when "info"
      mi.info_outline
    when "success"
      mi.check
    when "danger"
      mi.error_outline
    when "warning"
      mi.warning
    end
  end
end
