# frozen_string_literal: true
require 'pp'
require 'faraday'
require 'nokogiri'
require_relative '../lib/services/winewebsite/all_products_link_scrapper'
require_relative '../lib/services/winewebsite/product_page_scrapper'
require_relative '../lib/db/db_insert'
require_relative '../lib/db/db_wine'

# www.wine.com.br
start_page = 73
products_links_list = Winewebsite::AllProductsLinkScrapper.call(start_page)
products_links_list.each do |link|
  page_doc = URL::Parser.call(link)
  wine = Winewebsite::ProductPageScrapper.call(page_doc, link).to_hash
  WineDB.exist?(wine) ? WineDB.update(wine) : WineDB.insert(wine)
end