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
      url = product.image.file.nil? ? nil : product.image.thumb.url
      style = "product-img-thumb"
    when "medium"
      url = product.image.file.nil? ? nil : product.image.medium.url
      style = "product-img-medium"
    when "origin"
      url = product.image.file.nil? ? nil : product.image.url
      style = "product-img-origin"
    end
    image_tag(url || "http://ww2.sinaimg.cn/large/006tNc79gy1ffcsd4b3ugj307n07ndfv.jpg", class: style || size)
  end
end
