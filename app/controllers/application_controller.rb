class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    render_unauthorized
  end

  def current_ability
    @current_ability ||= Ability.new(current_admin)
  end

  def render_unauthorized
    render "#{Rails.root}/public/401", status: :unauthorized, layout: false, :format => :html
  end
end
