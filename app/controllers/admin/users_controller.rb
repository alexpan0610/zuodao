class Admin::UsersController < Admin::AdminController
  before_action :find_user_by_id, only: [:edit, :update, :destroy]

  def index
    @users = User.all.page(params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path, notice: "用户#{@user.title}更新成功！"
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:alert] = "用户#{@user.title}已被删除"
    else
      flash[:warning] = "用户#{@user.title}删除失败"
    end
    redirect_to admin_users_path
  end

  private

  def find_user_by_id
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :is_admin)
  end
end
