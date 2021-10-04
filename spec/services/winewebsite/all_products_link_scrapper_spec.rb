# o que essa classe faz?
# ao testar essa classe estamos testando
# all_products_link_scrapper.rb
# page_products_links_catcher.rb
# products_page_counter.rb

# o que essa classe faz?
# 1. pula de pagina em pagina no site, 
# 2. conta o numero de produtos
# 3. para cada pagina pega os links dos produtos

# eh nitido que deveria ter sido feito de outra forma ...
# deveria ter criado um servico apenas para passar a pagina e entao retornar o pagedoc dessa pagina
# outro servico para pegar esses links
# por fim um manager que iria retornar todos esses links

require_relative '../../../lib/services/winewebsite/all_products_links_scrapper'

# para testar precisamos testar um rotulo, pegar seu link e verificar se vai estar dentro do array retornado

produto_teste = 'https://www.wine.com.br/vinhos/famille-j-m-cazes-a-o-c-saint-estephe-2015/prod20238.html'

RSpec.describe Winewebsite::AllProductsLinkScrapper do

    it 'checa o numero de links de uma das paginas iniciais' do
        todos_links = Winewebsite::AllProductsLinkScrapper.call(1)
        expect(todos_links).to include(produto_teste) 
    end

end