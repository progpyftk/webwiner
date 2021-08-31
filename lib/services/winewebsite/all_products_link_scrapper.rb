# frozen_string_literal: true

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
      roller_pages
      @products_links
    end

    private

    def roller_pages
      while @page_number_of_products != 0
        puts "Page number: #{@page_counter}"
        puts "Pegandos os links da pagina: https://www.wine.com.br/vinhos/cVINHOS-p#{@page_counter}.html"
        page_doc = URL::Parser.call("https://www.wine.com.br/vinhos/cVINHOS-p#{@page_counter}.html")
        @page_number_of_products = ProductsPageCounter.call(page_doc)
        puts "Numero de produtos na pagina: #{@page_number_of_products}"
        @products_links << PageProductsLinksCatcher.call(page_doc)
        @products_links.flatten!
        puts "numero de links pegos nessa pagina: #{PageProductsLinksCatcher.call(page_doc).length}"
        puts "total de links pegos ate essa pagina #{@products_links.length}"
        @page_counter += 1
      end
    end
  end
end
