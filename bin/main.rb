# frozen_string_literal: true

require_relative '../lib/db_client'
require_relative '../lib/db_connection'
require_relative '../lib/db_table'
require_relative '../lib/wine'
require_relative '../lib/winestore_website'
require_relative '../lib/winestore_wine_page'

DATABASE = 'webwiner'
DBase.check(DATABASE) # 1. Checa se a basa de dados existe, caso nao, cria a base de dados
DBTable.create(DATABASE) # 2. Criar as tabelas caso nao existam

wine_store_website = WineStoreWebSite.new

all_products_links = wine_store_website.products_link # 3. Raspa todos os links de todos os vinhos do site

all_products_links.each do |link|
  wine_page = WineStoreWinePage.new(link)
  wine = wine_page.product_data # 3. Em cada link pega os dados do produto
  if DBClient.exist?('global_id', wine.global_id, 'wine_site', DATABASE) # 4. Checa se o vinho ja existe na DB
    DBClient.update(wine.to_hash, 'global_id', 'wine_site', DATABASE) # 5. Atualiza se ja existir
  else
    DBClient.add(wine.to_hash, 'wine_site', DATABASE) # 6. Inclui caso nao exista
  end
end
