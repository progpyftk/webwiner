# frozen_string_literal: true

require_relative '../application_service'

# namespacing WineWebsite specific for Wine store wibsite
module Winewebsite
  # PageProductsLinksCatcher: responsible to catch the products links in a specific page

  class PageProductsLinksCatcher < ApplicationService
    attr_reader :page_doc

    def initialize(page_doc)
      @page_doc = page_doc
    end

    def call
      page_links = page_doc.xpath('//*[@class="row ProductDisplay-name"]//a//@href').map(&:text)
      page_links.map! { |each_link| "https://www.wine.com.br#{each_link}" }
      page_links
    end
  end
end
