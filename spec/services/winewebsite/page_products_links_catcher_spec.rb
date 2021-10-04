require_relative '../../../lib/services/winewebsite/page_products_links_catcher'
require_relative '../../../lib/services/url/parser'

# o que essa classe faz?
# retorna os links de um pagedoc recebido

# pagedoc de uma determinada pagina - pagina 10
page_doc = URL::Parser.call("https://www.wine.com.br/vinhos/cVINHOS-p10.html")

# produto teste (tem sempre que conferir)
produto_teste_pag_10 = 'https://www.wine.com.br/vinhos/inspiracion-blanc-2020/prod25106.html'

RSpec.describe Winewebsite::PageProductsLinksCatcher do
    links = Winewebsite::PageProductsLinksCatcher.call(page_doc)
    it 'checa o numero de produtos na pagina eh igual a 9' do
        expect(links.length).to eq(9) 
    end

    it 'checa se determinado vinho da pagina 10 esta no array' do
        expect(links).to include(produto_teste_pag_10) 
    end
end