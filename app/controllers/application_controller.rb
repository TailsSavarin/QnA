class ApplicationController < ActionController::Base
  before_action :gon_user, unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_path, alert: exception.message }
      format.json { render json: {}, status: :forbidden }
      format.js { render file: Rails.root.join('public/403'), formats: [:html], status: :forbidden, layout: false }
    end
  end

  private

  def gon_user
    gon.user_id = current_user&.id
  end
end
