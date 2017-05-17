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
      content_tag(:i, "info_outline", class: "material-icons")
    when "success"
      content_tag(:i, "check", class: "material-icons")
    when "danger"
      content_tag(:i, "error_outline", class: "material-icons")
    when "warning"
      content_tag(:i, "warning", class: "material-icons")
    end
  end
end
