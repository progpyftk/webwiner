require 'faraday'
require 'nokogiri'
require 'pp'
require_relative 'wine.rb'

class ScrapWineSite
    @wine = Wine.new()

    FIRST_PAGE = "https://www.wine.com.br/vinhos/cVINHOS-p1.html"
    URL_PAGE_PIECE = "https://www.wine.com.br/vinhos/cVINHOS-p" # used to concatenate the full url in order to iterate over the product pages 
    MAIN_PAGE = "https://www.wine.com.br"
    PAGE_LINK_XPATH = '//*[@class="row ProductDisplay-name"]//a//@href' # xpath to find the product's links pages
    WINE_DATA_FEATURE_NAME = '//dt[@class="w-caption"]'  # xpath to find the wine features name at its main page
    WINE_DATA_FEATURE_VALUE = '//dd[@class="w-paragraph"]' # xpath to find the wine features value at its main page
    WINE_NAME_XPATH = '//h1[@class="PageHeader-title w-title--4  text-center "]' # xpath to find the wine's name at its main page
    START_PAGE_NUMBER = 70 # the to start scraping, in order to make test, increase it

    def self.products_link # return an array with all products links
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

    def self.product_data(link) # # return a wine object for each link
        res = Faraday.get(link) # request to the next page
        doc = Nokogiri::HTML res.body # parse the page html

        # getting the product store's sku using regex at wine link string
        @wine.link = link
        @wine.site_sku = link.scan(/(?=prod)(.*)(?=.html)/).flatten[0]
        @wine.global_id = link.scan(/(?=prod)(.*)(?=.html)/).flatten[0]
        
        # getting the grape, maker, year and regiom
        index = 0
        while index < doc.xpath(WINE_DATA_FEATURE_NAME).length
            unless doc.xpath(WINE_DATA_FEATURE_VALUE)[index] == nil
                @wine.grape = doc.xpath(WINE_DATA_FEATURE_VALUE)[index].text if doc.xpath(WINE_DATA_FEATURE_NAME)[index].text == "Uva"
                @wine.maker = doc.xpath(WINE_DATA_FEATURE_VALUE)[index].text if doc.xpath(WINE_DATA_FEATURE_NAME)[index].text == "Vinícola"
                @wine.year = doc.xpath(WINE_DATA_FEATURE_VALUE)[index].text.to_i if doc.xpath(WINE_DATA_FEATURE_NAME)[index].text == "Safra"
                @wine.region = doc.xpath(WINE_DATA_FEATURE_VALUE)[index].text if doc.xpath(WINE_DATA_FEATURE_NAME)[index].text == "País - Região"
                index += 1
            end
        end
        # getting the name
        @wine.name = doc.xpath(WINE_NAME_XPATH).first.text if doc.xpath(WINE_NAME_XPATH).first != nil
        @wine.year = @wine.name.scan(/\d{4}/).to_i if @wine.year = nil # many products dont have the year separated, instead they have it at their name

        # getting club price, sale price and regular price
        if doc.xpath('//price-box')[0]
            @wine.price_club = doc.xpath('//price-box').attr(':product').text.scan(/\d+\.\d+/)[0].to_f
            @wine.price_regular = doc.xpath('//price-box').attr(':product').text.scan(/\d+\.\d+/)[1].to_f
            @wine.price_sale = doc.xpath('//price-box').attr(':product').text.scan(/\d+\.\d+/)[2].to_f
        else
            @wine.price_club, @wine.price_regular, @wine.price_sale  = nil, nil, nil
        end
        @wine
    end
end









 



















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

