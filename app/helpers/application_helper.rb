module ApplicationHelper
  def toast_flashes
    flash.to_h.to_json
  end
end