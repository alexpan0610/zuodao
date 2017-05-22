class Admin::AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_required
  before_action :save_back_url, only: [:new, :edit, :destroy]
  layout "admin"
end
