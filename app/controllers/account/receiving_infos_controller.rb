class Account::ReceivingInfosController < ApplicationController
  before_action :authenticate_user!
  before_action :find_receiving_info_by_id, only: [:edit, :update, :destroy]

  def index
    @receiving_infos = current_user.receiving_infos
  end

  def new
    @receiving_info = ReceivingInfo.new
  end

  def create
    @receiving_info = ReceivingInfo.new(receiving_info_params)
    @receiving_info.user = current_user
    if @receiving_info.save
      redirect_to account_receiving_infos_path
    else
      render :new
    end
  end

  def update
    if @receiving_info.update(receiving_info_params)
      redirect_to account_receiving_infos_path, notice: "收货地址已成功修改！"
    else
      render :edit
    end
  end

  def destroy
    @receiving_info.destroy
    redirect_to account_receiving_infos_path, alert: "收货地址已删除！"
  end

  private

  def find_receiving_info_by_id
    @receiving_info = ReceivingInfo.find(params[:id])
  end

  def receiving_info_params
    params.require(:receiving_info).permit(:name, :cellphone, :address)
  end
end
