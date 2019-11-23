# frozen_string_literal: true

require 'json'
require 'net/http'
require 'openssl'

module RequestHelper
  class << self
    def request(uri, body, token = nil)
      uri = URI(uri)
      http = Net::HTTP.new(uri.host, uri.port)

      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      headers = { 'Content-type' => 'application/json' }
      # /session/create does not require token
      headers['Authorization'] = "Bearer #{token}" if token
      req = Net::HTTP::Post.new(uri, headers)
      req.body = body.to_json

      http.request(req)
    end
  end
end
