# frozen_string_literal: true

require_relative '../application_service'
require 'selenium-webdriver'
require 'json'
require 'C:\Users\loren\OneDrive\Área de Trabalho\projects\webwiner\lib\wine'
require_relative '../url/selenium_connector'

module EvinoWebsite
  class ProductPageScrapper < ApplicationService
    def initialize(url)
      @wine = Wine.new
      @wine.store = 'Evino'
      @driver = URL.SeleniumConnector.call(url)
    end

    def call
      scrap_page
      @driver.close
      @wine
    end

    private

    def scrap_page
      # tratar o json recebido e ver se corresponde ao que eu quero, geralmente é o 25 ou 24
      json_string = @driver.find_element(:xpath, '/html/head/script[24]').attribute('innerHTML')
      script_number = 22
      until json_string.include?('priceCurrency') || script_number == 27
        json_string = @driver.find_element(:xpath, "/html/head/script[#{script_number}]").attribute('innerHTML')
        script_number += 1
      end

      if json_string.include?('priceCurrency')
        @json_obj = JSON.parse(json_string)
        name
        maker
        store_sku
        price_sale
        link
        grape_region_year
      else
        puts 'não conseguiu pegar o json'
      end
    end

    def name
      @wine.name = @json_obj['name']
    end

    def maker
      @wine.maker = @json_obj['brand']
    end

    def store_sku
      @wine.store_sku = @json_obj['sku']
      @wine.global_id = @wine.store_sku
    end

    def price_sale
      @wine.price_sale = @json_obj['offers']['price']
    end

    def link
      @wine.link = @json_obj['offers']['url']
    end

    def grape_region_year
      # falta concatenar região e país
      puts @json_obj
      @json_obj['additionalProperty'].each do |each|
        puts each['name']
        case each['name']
        when 'Uvas'
          @wine.grape = each['value']
        when 'País'
          country = each['value']
          puts country
        when 'Região'
          region = each['value']
          puts region
        when 'Safra'
          @wine.year = each['value']
        end
        treat_region(country, region)
      end
    end

    def treat_region(country, region)
      if !country.nil? && !region.nil?
        @wine.region = country.to_s + "-#{region}"
      elsif !country.nil? && region.nil?
        @wine.region = country.to_s
      elsif country.nil? && !region.nil?
        @wine.region = region.to_s
      end
      puts @wine.region
    end
  end
end
