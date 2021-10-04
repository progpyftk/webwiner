# o que essa classe faz?
# faz o scrap da pagina do produto pegando seus atributos

require_relative '../../../lib/services/url/parser'
require_relative '../../../lib/services/winewebsite/product_page_scrapper'
require_relative '../../../lib/wine'

# vinho bear flag
link_produto_teste = 'https://www.wine.com.br/vinhos/bear-flag-red-blend-2018/prod23266.html'
page_doc = URL::Parser.call(link_produto_teste)

RSpec.describe Winewebsite::ProductPageScrapper do

    scrap_wine = Winewebsite::ProductPageScrapper.call(page_doc, link_produto_teste).to_hash
    
    wine = Wine.new
    wine.name = 'Bear Flag Red Blend 2018'
    wine.maker = 'Bear Flag'
    wine.year = 2018
    wine.grape = 'Merlot (95.00%), Outras uvas (4.00%), Dornfelder (1.00%)'
    wine.region = 'Estados Unidos - Califórnia'
    wine.link = 'https://www.wine.com.br/vinhos/bear-flag-red-blend-2018/prod23266.html'
    wine.price_club = 47.9
    wine.price_regular = 93.9
    wine.price_sale = 56.35
    wine.store_sku = 'prod23266'
    wine.store = 'Wine'
    wine.global_id = 'prod23266'
    wine = wine.to_hash
  
    it 'product scrap page' do
      expect(wine).to eq(scrap_wine)
    end

  end

