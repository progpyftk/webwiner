# frozen_string_literal: true

require_relative '../application_service'

# namespacing WineWebsite specific for Wine store wibsite
module Winewebsite
  # ProductsPageCounter: counts the number of products on each catalog page - finds the last page
  class ProductsPageCounter < ApplicationService
    def initialize(page_doc)
      @page_doc = page_doc
    end

    def call
      @page_doc.xpath('//*[@class="row ProductDisplay-name"]//a//@href').length
    end
  end
end
