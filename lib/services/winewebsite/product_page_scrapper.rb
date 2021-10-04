# frozen_string_literal: true

require_relative '../application_service'
require 'C:\Users\loren\OneDrive\Área de Trabalho\projects\webwiner\lib\wine'
require 'open-uri'

# namespacing WineWebsite specific for Wine store wibsite
module Winewebsite
  # ProductPageScrapper: responsibloe to scrap the product specific page catching all its features
  class ProductPageScrapper < ApplicationService
    def initialize(page_doc, link)
      @wine = Wine.new
      @wine.link = link
      @wine.store = 'Wine'
      @page_doc = page_doc
    end

    def call
      scrap_product_data
      @wine
    end

    private

    def scrap_product_data
      store_sku
      global_id
      name
      grape_region_year_maker
      wine_prices
    end

    def store_sku
      @wine.store_sku = @wine.link.scan(/(?=prod)(.*)(?=.html)/).flatten[0]
    end

    def global_id
      @wine.global_id = @wine.link.scan(/(?=prod)(.*)(?=.html)/).flatten[0]
    end

    def name
      name_xpath = '//h1[@class="PageHeader-title w-title--4  text-center "]'
      @wine.name = @page_doc.xpath(name_xpath).first.text unless @page_doc.xpath(name_xpath).first.nil?
    end

    def grape_region_year_maker
      feature_name = '//dt[@class="w-caption"]'
      feature_value = '//dd[@class="w-paragraph"]'
      @page_doc.xpath(feature_name).each_with_index do |_each, index|
        case @page_doc.xpath(feature_name)[index].text
        when 'Uva'
          @wine.grape = @page_doc.xpath(feature_value)[index].text
        when 'Vinícola'
          @wine.maker = @page_doc.xpath(feature_value)[index].text
        when 'Safra'
          @wine.year = @page_doc.xpath(feature_value)[index].text.to_i
          treat_year if @wine.year.nil?
        when 'País - Região'
          @wine.region = @page_doc.xpath(feature_value)[index].text
        end
      end
    end

    def treat_year
      # ainda tem que trabalhar aqui
      if @wine.name.is_a?(String)
        year = @wine.name.scan(/\d{4}/)
        @wine.year = nil if year[0].nil?
      end
    end

    def wine_prices
      if @page_doc.xpath('//price-box')[0]
        @wine.price_club = @page_doc.xpath('//price-box').attr(':product').text.scan(/\d+\.\d+/)[0].to_f
        @wine.price_regular = @page_doc.xpath('//price-box').attr(':product').text.scan(/\d+\.\d+/)[1].to_f
        @wine.price_sale = @page_doc.xpath('//price-box').attr(':product').text.scan(/\d+\.\d+/)[2].to_f
      else
        @wine.price_club = nil
        @wine.price_regular = nil
        @wine.price_sale = nil
      end
    end
  end
end
