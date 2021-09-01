# frozen_string_literal: true

require_relative '../application_service'

module Winewebsite
  class ProductsPageCounter < ApplicationService
    def initialize(page_doc)
      @page_doc = page_doc
    end

    def call
      @page_doc.xpath('//*[@class="row ProductDisplay-name"]//a//@href').length
    end
  end
end
