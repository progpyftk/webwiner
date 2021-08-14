# frozen_string_literal: true

require_relative '../lib/db_client'
require_relative '../lib/db_connection'
require_relative '../lib/db_table'
require_relative '../lib/wine'
require_relative '../lib/scrap_wine_website'

DATABASE = 'webwiner'
DBase.check(DATABASE) # 1. Checa se a basa de dados existe, caso não, cria a base de dados
DBTable.create(DATABASE) # 2. Criar as tabelas caso não existam
links_wine = ScrapWineSite.products_link # 3. Pega os links de todos os vinhos do site
links_wine.each do |link|
  wine = Wine.new
  wine = ScrapWineSite.product_data(link) # 4. Pega as informações de cada um dos vinhos na sua respecitiva pagina
  if DBClient.exist?('global_id', wine.global_id, 'wine_site', DATABASE) # 5. Checa se o vinho já existe na DB
    DBClient.update(wine.to_hash, 'global_id', 'wine_site', DATABASE) # 5. Atualiza se já existir
  else
    DBClient.add(wine.to_hash, 'wine_site', DATABASE) # 6. Inclui caso não exista
  end
end

# wine.site_sku ="prod5444"
# wine.store = "Wine"
# wine.name = "Vinho do Lorenzo"
# wine.year = 1999
# wine.maker = "Lorenzo"
# wine.region = "Colatina"
# wine.global_id = "prod5444"
# wine.grape = "Roxa"
# wine.link = "www.teste.com.br"
# wine.price_club = 54.21
# wine.price_regular =  50.20
# wine.price_sale = 21.40
# winehash = wine.to_hash
