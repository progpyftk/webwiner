# frozen_string_literal: true
require_relative '../lib/services/winewebsite/all_products_link_scrapper'
require_relative '../lib/services/winewebsite/product_page_scrapper'
require_relative '../lib/db/db_wine'

# www.wine.com.br
start_page = 70
products_links_list = Winewebsite::AllProductsLinkScrapper.call(start_page)
products_links_list.each do |link|
  page_doc = URL::Parser.call(link)
  wine = Winewebsite::ProductPageScrapper.call(page_doc, link).to_hash
  puts wine
  WineDB.exist?(wine) ? WineDB.update(wine) : WineDB.insert(wine)
end

# www.evino.com.br


