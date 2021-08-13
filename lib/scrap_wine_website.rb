# -------------------------------www.wine.com.br--------------------------------------------#
#
#        Scraping the www.wine.com.br website. The largest online wine store in Brazil.
#
# ||||Objectives||||
#
# 1 - get all products list with their info.
#         Wine info: name, maker, year, region, club price, regular price, sale price
# 
# 2 - break the wine bundles into individual wines in order to check their cost / benefit
#
# -------------------------------www.wine.com.br--------------------------------------------#

# TODO
#    1. Fix timeout problem - use begin / rescue approach
#          When the request takes more than 60 seconds, it raises an error.
#          C:/Ruby27/lib/ruby/2.7.0/net/protocol.rb:217:in `rbuf_fill': Net::ReadTimeout with #<TCPSocket:(closdTimeout)
#   
#    2. Check how many were success scraped by page, then, before scraping all the products again, 
#            retry scraping ones with problem
#

require 'faraday'
require 'nokogiri'
require_relative 'db_connection'
require 'pp'

class WineWebsite

    # a classe Wine ainda será criada, por isso os atributos de um vinho não estão aqui nessa classe
    # essa classe Wine que será criada, servirá para todos os sites de vendas, pois de todos queremos as mesma informações.

    FIRST_PAGE = "https://www.wine.com.br/vinhos/cVINHOS-p1.html"
    URL_PAGE_PIECE = "https://www.wine.com.br/vinhos/cVINHOS-p" # used to concatenate the full url in order to iterate over the product pages 
    MAIN_PAGE = "https://www.wine.com.br"
    PAGE_LINK_XPATH = '//*[@class="row ProductDisplay-name"]//a//@href' # xpath to find the product's links pages
    WINE_DATA_FEATURE_NAME = '//dt[@class="w-caption"]'  # xpath to find the wine features name at its main page
    WINE_DATA_FEATURE_VALUE = '//dd[@class="w-paragraph"]' # xpath to find the wine features value at its main page
    WINE_NAME_XPATH = '//h1[@class="PageHeader-title w-title--4  text-center "]' # xpath to find the wine's name at its main page
    START_PAGE_NUMBER = 60 # the to start scraping, in order to make test, increase it


    def products_link
        products_link = []
        page_number = START_PAGE_NUMBER # change this value in order to test faster
        products = 1
        until products == 0 # || page_number == 10 # delete this comment in order to test it faster
            res = Faraday.get(URL_PAGE_PIECE + page_number.to_s + ".html") # request to the next page
            doc = Nokogiri::HTML res.body # parse the page html
            products = doc.xpath(PAGE_LINK_XPATH).length # check the number of products in the page - wheh it reachs 0 means it is done
            puts "Products in the page #{page_number} is #{products} "
            products_link << doc.xpath(PAGE_LINK_XPATH).map {|link| link.text} 
            page_number += 1
        end
        products_link.flatten!.map! { |each_link| MAIN_PAGE + each_link }
    end

    def get_product_data(link)
        res = Faraday.get(link) # request to the next page
        doc = Nokogiri::HTML res.body # parse the page html
        wine_data = {}

        # getting the product store's sku using regex at wine link string
        wine_data[:link] = link
        wine_data[:site_sku] = link.scan(/(?=prod)(.*)(?=.html)/).flatten[0]
        wine_data[:global_id] = link.scan(/(?=prod)(.*)(?=.html)/).flatten[0]
        
        # getting the grape, maker, year and regiom
        index = 0
        while index < doc.xpath(WINE_DATA_FEATURE_NAME).length
            unless doc.xpath(WINE_DATA_FEATURE_VALUE)[index] == nil
                wine_data[:grape] = doc.xpath(WINE_DATA_FEATURE_VALUE)[index].text if doc.xpath(WINE_DATA_FEATURE_NAME)[index].text == "Uva"
                wine_data[:maker] = doc.xpath(WINE_DATA_FEATURE_VALUE)[index].text if doc.xpath(WINE_DATA_FEATURE_NAME)[index].text == "Vinícola"
                wine_data[:year] = doc.xpath(WINE_DATA_FEATURE_VALUE)[index].text.to_i if doc.xpath(WINE_DATA_FEATURE_NAME)[index].text == "Safra"
                wine_data[:region] = doc.xpath(WINE_DATA_FEATURE_VALUE)[index].text if doc.xpath(WINE_DATA_FEATURE_NAME)[index].text == "País - Região"
                index += 1
            end
        end
        # getting the name
        wine_data[:name] = doc.xpath(WINE_NAME_XPATH).first.text if doc.xpath(WINE_NAME_XPATH).first != nil
        p wine_data[:name]
        p wine_data[:year]
        
        #wine_data[:year] = wine_data.scan(/\d{4}/) # many products dont have the year separated, instead they have it at their name
        
        # getting club price, sale price and regular price
        if doc.xpath('//price-box')[0]
            wine_data[:club_price] = doc.xpath('//price-box').attr(':product').text.scan(/\d+\.\d+/)[0].to_f
            wine_data[:regular_price] = doc.xpath('//price-box').attr(':product').text.scan(/\d+\.\d+/)[1].to_f
            wine_data[:sale_price] = doc.xpath('//price-box').attr(':product').text.scan(/\d+\.\d+/)[2].to_f
        else
            wine_data[:club_price] = nil
            wine_data[:regular_price] = nil
            wine_data[:sale_price] = nil
        end

        # to do:  check if the year was found, if not, take it from the wine's name
        wine_data[:year] = 1000 unless wine_data.has_key?(:year) # just a temporary work around
        wine_data

    end

    def get_all_products
        wines = []
        products_link.each do |link|
            wine_hash = get_product_data(link)
            wines << wine_hash
        end
        wines
    end

end


# Database check and table creations
WineDB.check_db

# Get all the product at the website
scraper = WineWebsite.new()
site_products = scraper.get_all_products

# Add these productsto the database
site_products.each { |each_wine| WineDB.insert_wine('wine', each_wine) }

# testing if we try to add the same global_id twice it raises an error if it is duplicated, in this case we must update the product




#site_products.each { |each_wine| WineDB.insert_wine(each_wine) }






 



















=begin
wine_data_list = products_link.map { |link| wine_scrap.get_product_data(link) }
puts"------------------------------------------------"
wine_data_list.each do |each|
    puts "Name: -------------#{each[:name]}"
    puts "Grape: ------------#{each[:grape]}"
    puts "Region: -----------#{each[:region]}"
    puts "Year: -------------#{each[:year]}"
    puts "Maker: ------------#{each[:maker]}"
    puts "Club price: -------#{each[:club_price]}"
    puts "Regular price: ----#{each[:regular_price]}"
    puts "Sale price: -------#{each[:sale_price]}"
    puts"------------------------------------------------"
end

=end

