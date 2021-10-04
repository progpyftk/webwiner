# frozen_string_literal: true

require_relative '../lib/services/winewebsite/all_products_link_scrapper'
require_relative '../lib/services/evinowebsite/all_products_links_scrapper'
require_relative '../lib/services/winewebsite/product_page_scrapper'
require_relative '../lib/services/evinowebsite/product_page_scrapper'
require_relative '../lib/db/db_wine'
require_relative '../lib/db/db_evino'

# www.wine.com.br
start_page = 1
products_links_list = Winewebsite::AllProductsLinkScrapper.call(start_page)
products_links_list.each do |link|
  page_doc = URL::Parser.call(link)
  wine = Winewebsite::ProductPageScrapper.call(page_doc, link).to_hash
  WineDB.exist?(wine) ? WineDB.update(wine) : WineDB.insert(wine)
end


# www.evino.com.br
url = 'https://www.evino.com.br/vinhos'
products_links_list = EvinoWebsite::AllProductsLinksScrapper.call(url)
products_links_list.each do |link|
  wine = EvinoWebsite::ProductPageScrapper.call(link).to_hash
  EvinoDB.exist?(wine) ? EvinoDB.update(wine) : EvinoDB.insert(wine)
end
