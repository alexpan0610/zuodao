module ProductsHelper

  def render_product_image_thumb(product)
    render_product_image(product, "thumb")
  end

  def render_product_image_medium(product)
    render_product_image(product, "medium")
  end

  def render_product_image_origin(product)
    render_product_image(product, "origin")
  end

  def render_product_image(product, size)
    case size
    when "thumb"
      url = product.image.file.nil? ? "https://ws1.sinaimg.cn/large/006tNc79gy1ffspqvomprj305k05kmxu.jpg" : product.image.thumb.url
      style = "product-img-thumb"
    when "medium"
      url = product.image.file.nil? ? "http://ww3.sinaimg.cn/large/006tNc79gy1ffspoj7jr4j30go0gon04.jpg" : product.image.medium.url
      style = "product-img-medium"
    when "origin"
      url = product.image.file.nil? ? "https://ws4.sinaimg.cn/large/006tNc79gy1ffspp82i2zj30m80godhh.jpg" : product.image.url
      style = "product-img-origin"
    end
    image_tag(url || "http://ww2.sinaimg.cn/large/006tNc79gy1ffcsd4b3ugj307n07ndfv.jpg", class: style || size)
  end
end
