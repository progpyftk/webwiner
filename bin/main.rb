# frozen_string_literal: true
require 'faraday'
require 'nokogiri'
require_relative '../lib/services/winewebsite/all_products_link_scrapper'
require_relative '../lib/services/winewebsite/product_page_scrapper'


# www.wine.com.br
start_page = 60
Winewebsite::AllProductsLinkScrapper.call(start_page)












=begin
wine = Wine.new
wine.name = 'CAFE FERRADO DEMAIS'
wine.region = 'São Jacinto'
wine.year = 999_999
wine.global_id = 'TOMEII'
wine.maker = 'CABRINI WINES'
wine.price_club = 10.50
wine = wine.to_hash
table = 'wine_site'

field = 'global_id'
field_value = 'GID_TESTE'

WineDB.insert(wine) unless WineDB.exist?(wine)
WineDB.update(wine)
=end