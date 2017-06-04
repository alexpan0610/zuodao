class Admin::AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :save_back_url
  before_action :admin_required, except: [:index, :new, :edit, :show]
  layout "admin"
end
