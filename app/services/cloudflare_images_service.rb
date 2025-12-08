class CloudflareImagesService
  include HTTParty
  base_uri "https://api.cloudflare.com/client/v4"

  class UploadError < StandardError; end
  class DeleteError < StandardError; end

  def initialize
    @account_id = ENV["CLOUDFLARE_ACCOUNT_ID"]
    @api_token = ENV["CLOUDFLARE_IMAGE_TOKEN"]
    @hash_key = ENV["CLOUDFLARE_IMAGE_HASH_KEY"]
  end

  def upload(file)
    response = self.class.post(
      "/accounts/#{@account_id}/images/v1",
      headers: auth_headers,
      body: { file: file },
      multipart: true
    )

    handle_response(response) do |result|
      result["id"]
    end
  end

  def upload_from_url(url)
    response = self.class.post(
      "/accounts/#{@account_id}/images/v1",
      headers: auth_headers,
      body: { url: url }
    )

    handle_response(response) do |result|
      result["id"]
    end
  end

  def delete(image_id)
    response = self.class.delete(
      "/accounts/#{@account_id}/images/v1/#{image_id}",
      headers: auth_headers
    )

    handle_response(response, error_class: DeleteError) do |_result|
      true
    end
  end

  def url_for(image_id, variant: "public")
    return nil if image_id.blank?
    "https://imagedelivery.net/#{@hash_key}/#{image_id}/#{variant}"
  end

  def self.url_for(image_id, variant: "public")
    new.url_for(image_id, variant: variant)
  end

  private

  def auth_headers
    { "Authorization" => "Bearer #{@api_token}" }
  end

  def handle_response(response, error_class: UploadError)
    if response.success? && response.parsed_response["success"]
      yield response.parsed_response["result"]
    else
      errors = response.parsed_response&.dig("errors") || []
      error_message = errors.map { |e| e["message"] }.join(", ")
      raise error_class, "Cloudflare Images API error: #{error_message}"
    end
  end
end
