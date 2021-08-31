# frozen_string_literal: true

require 'faraday'
require 'nokogiri'
require 'pp'
# Quais as responsabilidade dessa classe?
# 2. Fazer o parse da url do site desejado (DOC)
# 3. Pegar o link da página de cada vinho e adicionar em array - especifico para o site da wine
# 4. Retornar o array com todos os links - especifico para o site da wine
class WineStoreWebSite
  FIRST_PAGE = 'https://www.wine.com.br/vinhos/cVINHOS-p1.html'
  URL_PAGE_PIECE = 'https://www.wine.com.br/vinhos/cVINHOS-p' # used to concatenate the full url in order to iterate over the product pages
  MAIN_PAGE = 'https://www.wine.com.br'
  PAGE_LINK_XPATH = '//*[@class="row ProductDisplay-name"]//a//@href' # xpath to find the product's links pages
  START_PAGE_NUMBER = 70 # the to start scraping, in order to make test, increase it

  # return an array with all products links from start page to the last page
  def products_link
    products_link = []
    page_number = START_PAGE_NUMBER # change this value in order to test faster
    products = 1
    until products.zero? # || page_number == 10 # delete this comment in order to test it faster
      res = Faraday.get("#{URL_PAGE_PIECE}#{page_number}.html") # request to the next page
      doc = Nokogiri::HTML res.body # parse the page html
      products = doc.xpath(PAGE_LINK_XPATH).length # check the number of products in the page - wheh it reachs 0 means it is done
      puts "Products in the page #{page_number} is #{products} "
      products_link << doc.xpath(PAGE_LINK_XPATH).map(&:text)
      page_number += 1
    end
    products_link.flatten!.map! { |each_link| MAIN_PAGE + each_link }
  end
end
