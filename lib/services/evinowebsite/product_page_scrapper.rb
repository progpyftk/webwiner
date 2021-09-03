require_relative '../application_service'
require 'selenium-webdriver'
require_relative 'connect_url.rb'

require 'json'

require 'C:\Users\loren\OneDrive\Área de Trabalho\projects\webwiner\lib\wine'

module EvinoWebsite

    class ProductPageScrapper < ApplicationService

        def initialize(url)
            @wine = Wine.new
            @driver = ConnectURL.call(url)
        end

        def call
            Selenium::WebDriver::Wait.new(:timeout => 10)
            self.name
            self.sale_price
            #return @wine
        end

        private

        def 

        def name
            @driver.find_element(:xpath, "//h2[@itemprop='name']").text
        end

        def sale_price
            json_string =  @driver.find_element(:xpath, "/html/head/script[24]").attribute('innerHTML')
            json_obj = JSON.parse(json_string)
            puts json_obj['brand']
            puts json_obj['name']
            puts json_obj['sku']
            puts json_obj['offers']['price']
            puts json_obj['offers']['url']
            json_obj['additionalProperty'].each do |each|

                case each['name']
                when "Uvas"
                    puts each['value']
                when "País"
                    puts each['value']
                when 'Região'
                    puts each['value']
                when "Safra"
                    puts each['value']
                end
            end
        end
        
        
    end
  

end

EvinoWebsite::ProductPageScrapper.call('https://www.evino.com.br/product/chateau-tarin-2018-240121.html')