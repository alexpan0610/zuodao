class Admin::UsersController < Admin::AdminController
  before_action :find_user_by_id, only: [:edit, :update, :destroy]

  def index
    @users = User.all.asc.page(params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "用户#{@user.email}保存成功"
      back admin_users_path
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "用户#{@user.email}已更新"
      back admin_users_path
    else
      render :edit
    end
  end

  def destroy
    if @user == current_user
      flash[:alert] = "不能删除当前账户"
    elsif @user.admin?
      flash[:warning] = "不能删除管理员账户"
    else
      if @user.destroy
        flash[:alert] = "用户#{@user.email}已被删除"
      else
        flash[:warning] = "用户#{@user.email}删除失败"
      end
    end
    back admin_users_path
  end

  private

  def find_user_by_id
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :role_type)
  end
end
