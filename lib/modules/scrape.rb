require 'net/http'

module Scrape
  SCRAPE_TOKEN = ENV['SCRAPE_TOKEN']

  DEFAULT_QUERY = {
    token: SCRAPE_TOKEN
  }

  class << self
    def scrape(resource, **query)
      response = Net::HTTP.get_response \
        URI::HTTPS.build \
          host: 'australia-southeast1-noutube-432804.cloudfunctions.net',
          path: "/noutube-scrape/#{resource}",
          query: URI.encode_www_form(DEFAULT_QUERY.merge(query))
      return nil unless response.code == '200'
      JSON.parse(response.body)
    rescue
      nil
    end
  end
end
