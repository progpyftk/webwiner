# o que essa classe faz?
# expande a pagina da evino e retorna seu doc expandido
# o que devo testar? o principal eh a expansao da pagina, logo vou testar se ela clica no
# botao de mais produtos mais que 4 vezes por exemplo

require_relative '../../../lib/services/evinowebsite/page_expander'

RSpec.describe EvinoWebsite::PageExpander do
    page = EvinoWebsite::PageExpander.new('https://www.evino.com.br/vinhos')
    page.call
    
    it 'count the number of clicks at Mais Produtos buttom' do
        expect(page.number_of_clicks).to be > 5
    end

end




