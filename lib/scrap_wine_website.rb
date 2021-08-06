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
    PAGE_LINK_XPATH = '//*[@class="row ProductDisplay-name"]//a//@href' # xpath to find the product's links pages

    def products_link
        products_link = []
        page_number = 1
        products = 1
        until products == 0
            res = Faraday.get("https://www.wine.com.br/vinhos/cVINHOS-p" + page_number.to_s + ".html") # request to the next page
            doc = Nokogiri::HTML res.body # parse the page html
            products = doc.xpath(PAGE_LINK_XPATH).length # check the number of products in the page - wheh it reachs 0 means it is done
            products_link << doc.xpath(PAGE_LINK_XPATH).map {|link| link.text} 
            page_number += 1
        end
        products_link.flatten!.map! { |each_link| "https://www.wine.com.br" + each_link }
    end

end

wine_scrap = WineWebsite.new()

puts wine_scrap.products_link.length
puts wine_scrap.products_link