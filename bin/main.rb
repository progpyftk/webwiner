# frozen_string_literal: true
require 'faraday'
require 'nokogiri'
require_relative '../lib/services/winewebsite/products_link_manager'

start_page = 65
puts Winewebsite::ProductsLinkManager.call(start_page)











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