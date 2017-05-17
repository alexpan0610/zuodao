module ProductsHelper

  def render_product_image(product, style)
    if product.images.present?
      image_tag(product.images[0].thumb.url, class: style)
    else
      image_tag("http://ww2.sinaimg.cn/large/006tNc79gy1ffcsd4b3ugj307n07ndfv.jpg", class: style)
    end
  end

  def render_product_detail_image(product)
    if product.images.present?
      image_tag(product.images[0].medium.url, class: "product-img")
    else
      image_tag("http://ww2.sinaimg.cn/large/006tNc79gy1ffcsd4b3ugj307n07ndfv.jpg", class: "product-img")
    end
  end
end
