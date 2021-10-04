require_relative '../../../lib/services/evinowebsite/product_page_scrapper'
require_relative '../../../lib/wine'
require 'json'

# o que essa classe faz?
# recebe um link de um vinho e a partir dele pega as propriedades do vinho
# devemos então escolher um vinho na evino e pegar suas propriedades e comparar com a saída
# https://www.evino.com.br/product/don-simon-seleccion-tempranillo-67821.html

RSpec.describe EvinoWebsite::ProductPageScrapper do
    link = 'https://www.evino.com.br/product/don-simon-seleccion-tempranillo-67821.html'
    
    wine = Wine.new
    wine.name = 'Don Simon Selección Tempranillo'
    wine.maker = 'J. García Carrión'
    wine.year = nil
    wine.grape = 'Tempranillo'
    wine.region = "Castilla-La Mancha"
    wine.link = 'https://www.evino.com.br/product/don-simon-seleccion-tempranillo-67821.html'
    wine.price_club = nil
    wine.price_regular = nil
    wine.price_sale = '34.90'
    wine.store_sku = '1646870'
    wine.store = 'Evino'
    wine.global_id = '1646870'
    
    wine = wine.to_hash
    scrap_wine = EvinoWebsite::ProductPageScrapper.call(link).to_hash
    
    it 'product scrap page' do
        expect(wine).to eq(scrap_wine)
    end

end