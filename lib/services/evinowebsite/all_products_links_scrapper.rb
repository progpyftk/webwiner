# frozen_string_literal: true

require 'selenium-webdriver'
require_relative '../application_service'
require_relative 'page_expander'

module EvinoWebsite
  # return an array with all products links from a received nokogiri doc
  class AllProductsLinksScrapper < ApplicationService
    def initialize(url)
      @page_doc = EvinoWebsite::PageExpander.call(url)
    end

    def call
      scrap_products_links
      @products_links
    end

    private

    def scrap_products_links
      @products_links = @page_doc.xpath("//div[@class='ProductTile__Content']//a//@href").map(&:text)
      @products_links.map! { |link| 'https://www.evino.com.br'+link }
    end
  end
end


