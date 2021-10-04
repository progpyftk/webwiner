# frozen_string_literal: true

# o que essa classe faz?

# 2 - pega todos os links de todos os produtos a partir de um pagedoc
require_relative '../../../lib/services/evinowebsite/all_products_links_scrapper'

link = 'https://www.evino.com.br/product/don-simon-seleccion-tempranillo-67821.html'

RSpec.describe EvinoWebsite::AllProductsLinksScrapper do
  it 'link de algum vinho tradicional esta na lista' do
    produtos = EvinoWebsite::AllProductsLinksScrapper.call('https://www.evino.com.br/vinhos')
    puts produtos
    expect(produtos).to include(link)
  end
end
