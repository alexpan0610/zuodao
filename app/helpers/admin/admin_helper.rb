module Admin::AdminHelper
  
  def render_active(func)
    params[:controller] == "admin/#{func}" ? "active" : ""
  end
end
