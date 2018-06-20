module AdminHelper
  def current_section?(name, params)
    "is-active" if params[:controller] == name
  end
end
