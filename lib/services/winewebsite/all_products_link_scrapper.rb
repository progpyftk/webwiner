require_relative '../application_service'
require_relative 'products_page_counter'
require_relative 'page_products_links_catcher'
require_relative '../url/parser'

module Winewebsite
   class AllProductsLinkScrapper < ApplicationService

    attr_reader :products_links

    def initialize(start_page)
        @products_links = []
        @page_counter = start_page
        @page_number_of_products = 1
    end

    def call
        self.roller_pages
        @products_links
    end

    private
    
    def roller_pages
        while @page_number_of_products != 0
           page_doc = URL::Parser.call("https://www.wine.com.br/vinhos/cVINHOS-p#{@page_counter}.html")
           @page_number_of_products = ProductsPageCounter.call(page_doc)
           @products_links << PageProductsLinksCatcher.call(page_doc)
           @page_counter += 1
        end
    end
   end

end


