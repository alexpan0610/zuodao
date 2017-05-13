class Account::AddressesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_address_by_id, only: [:edit, :update, :destroy, :set_default]

  def index
    @addresses = current_user.addresses
  end

  def new
    @address = Address.new
  end

  def create
    @address = Address.new(address_params)
    @address.user = current_user
    if @address.save
      save()
    else
      render :new
    end
  end

  def update
    if @address.update(address_params)
      save()
    else
      render :edit
    end
  end

  def destroy
    @address.destroy
    redirect_to account_addresses_path, alert: "收货地址已删除！"
  end

  def set_default
    current_user.default_address = @address
    @addresses = current_user.addresses
    @selected = params[:selected].present? ? Address.find(params[:selected]) : nil
  end

  private

  def save
    if params[:commit].include?("设为默认")
      current_user.default_address = @address
    end
    if params[:action] == "update"
      flash[:notice] = "收货地址已成功修改！"
    end
    redirect_to account_addresses_path
  end

  def find_address_by_id
    @address = Address.find(params[:id])
  end

  def address_params
    params.require(:address).permit(:name, :cellphone, :address)
  end
end
