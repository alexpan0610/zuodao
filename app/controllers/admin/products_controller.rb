class Admin::ProductsController < Admin::AdminController
  before_action :find_product_by_id, only: [:edit, :update, :destroy]

  def index
    @products = Product.all.includes(:category).page(params[:page]).per_page(10)
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to admin_products_path
    else
      render :new
    end
  end

  def update
    if @product.update(product_params)
      redirect_to admin_products_path, notice: "产品#{@product.title}更新成功！"
    else
      render :edit
    end
  end

  def destroy
    if @product.destroy
      flash[:alert] = "产品#{@product.title}已被删除"
    else
      flash[:warning] = "产品#{@product.title}删除失败"
    end
    redirect_to admin_products_path
  end

  private

  def find_product_by_id
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:image, :title, :description, :price, :quantity, :category_id)
  end
end
