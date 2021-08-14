# frozen_string_literal: true

# this class defines a wine object
class Wine

  attr_accessor :name, :maker, :year, :grape, :region, :link, :price_club, :price_regular, :price_sale, :site_sku,
                :store

  def add
    conn = PG.connect(host: 'localhost', password: 'admin', user: 'postgres', dbname: 'webwiner')
     table_name = wine_site if self.store == "Wine"
     table_name = wine_site if self.store == "Evino"

    sql = "INSERT INTO #{table_name} (
      year, name, maker, region, grape, link, price_club, price_regular, price_sale, site_sku, global_id
    ) VALUES
    ( $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11 )"

    begin
      conn.prepare('save', sql) # values must match the same order as sql statement
      values = [wine_hash[:year], wine_hash[:name], wine_hash[:maker], wine_hash[:region],
                wine_hash[:grape], wine_hash[:link], wine_hash[:club_price], wine_hash[:regular_price],
                wine_hash[:sale_price], wine_hash[:site_sku], wine_hash[:global_id]]
      conn.exec_prepared('save', values) # this method requires an array as second argument
      conn.close
    rescue # StandardError => e # if it alreay exists, we are going to update it
      conn.close
      uptade_wine(site, wine_hash) # is it right to use the begin/rescue structure for it?
    end

  end




end
