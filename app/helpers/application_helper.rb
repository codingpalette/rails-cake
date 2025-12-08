module ApplicationHelper
  def cloudflare_image_tag(record, attribute, **options)
    variant = options.delete(:variant) || "public"

    case attribute
    when :images
      url = record.first_image_url(variant: variant)
      return placeholder_image_tag(options) unless url
      image_tag(url, **options)
    when :image
      url = record.image_url(variant: variant)
      return placeholder_image_tag(options) unless url
      image_tag(url, **options)
    when :profile_image
      url = record.profile_image_url(variant: variant)
      return placeholder_image_tag(options) unless url
      image_tag(url, **options)
    else
      placeholder_image_tag(options)
    end
  end

  def cloudflare_image_urls(record, attribute, variant: "public")
    record.send("#{attribute}_urls", variant: variant)
  end

  private

  def placeholder_image_tag(options)
    tag.div(class: options[:class] || "bg-gray-200")
  end
end
