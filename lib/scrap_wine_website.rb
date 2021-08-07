# -------------------------------www.wine.com.br--------------------------------------------#
#
#        Scraping the www.wine.com.br website. The largest online wine store in Brazil.
#
#      Objectives:
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
    URL_PAGE_PIECE = "https://www.wine.com.br/vinhos/cVINHOS-p"
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
            products_link << doc.xpath(PAGE_LINK_XPATH).map {|link| link.text} 
            page_number += 1
            puts ".....page number: #{page_number}"
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
        wine_data[:name] = doc.xpath(WINE_NAME_XPATH).first.text
        # getting club price, sale price and regular price
        wine_data
    end

end

wine_scrap = WineWebsite.new()

p wine_scrap.get_product_data("https://www.wine.com.br/vinhos/ballade-riesling-2020/prod26084.html")

