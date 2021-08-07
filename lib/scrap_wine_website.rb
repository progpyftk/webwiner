# -------------------------------www.wine.com.br--------------------------------------------#
#
#        Scraping the www.wine.com.br website. The largest online wine store in Brazil.
#
# ||||Objectives||||
#
# 1 - get all products list with its info.
#         Wine info: name, maker, year, region, club price, regular price, sale price
# 
# 2 - separate the wine kits into individual wines in order to check its cost / benefit
#
# -------------------------------www.wine.com.br--------------------------------------------#

require 'faraday'
require 'nokogiri'

class WineWebsite

    FIRST_PAGE = "https://www.wine.com.br/vinhos/cVINHOS-p1.html"
    URL_PAGE_PIECE = "https://www.wine.com.br/vinhos/cVINHOS-p" # used to concatenate the full url in order to iterate over the product pages 
    MAIN_PAGE = "https://www.wine.com.br"
    PAGE_LINK_XPATH = '//*[@class="row ProductDisplay-name"]//a//@href' # xpath to find the product's links pages
    WINE_DATA_FEATURE_NAME = '//dt[@class="w-caption"]'  # xpath to find the wine features name at its main page
    WINE_DATA_FEATURE_VALUE = '//dd[@class="w-paragraph"]' # xpath to find the wine features value at its main page
    WINE_NAME_XPATH = '//h1[@class="PageHeader-title w-title--4  text-center "]' # xpath to find the wine's name at its main page

    def products_link
        products_link = []
        page_number = 1
        products = 1
        until products == 0
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
        index = 0
        # getting the grape, maker, year and regiom
        while index < doc.xpath(WINE_DATA_FEATURE_NAME).length
            wine_data[:grape] = doc.xpath(WINE_DATA_FEATURE_VALUE)[index].text if doc.xpath(WINE_DATA_FEATURE_NAME)[index].text == "Uva"
            wine_data[:maker] = doc.xpath(WINE_DATA_FEATURE_VALUE)[index].text if doc.xpath(WINE_DATA_FEATURE_NAME)[index].text == "Vinícola"
            wine_data[:year] = doc.xpath(WINE_DATA_FEATURE_VALUE)[index].text if doc.xpath(WINE_DATA_FEATURE_NAME)[index].text == "Safra"
            wine_data[:region] = doc.xpath(WINE_DATA_FEATURE_VALUE)[index].text if doc.xpath(WINE_DATA_FEATURE_NAME)[index].text == "País - Região"
            index += 1
        end
        # getting the name
        wine_data[:name] = doc.xpath(WINE_NAME_XPATH).first.text if doc.xpath(WINE_NAME_XPATH)
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
        wine_data
    end

end

wine_scrap = WineWebsite.new()
products_link = wine_scrap.products_link
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
