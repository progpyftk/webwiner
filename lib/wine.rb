
require 'pg'

class Wine

  attr_accessor :name, :maker, :year, :grape, :region, :link, :price_club, :price_regular, :price_sale, :site_sku,
                :store, :global_id

  def add
    conn = PG.connect(host: 'localhost', password: 'admin', user: 'postgres', dbname: 'webwiner')
     table_name = "wine_site"

    sql = "INSERT INTO #{table_name} (
      year, name, maker, region, grape, link, price_club, price_regular, price_sale, site_sku, global_id
    ) VALUES  ( $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11 )"
    
    values = [self.year, self.name, self.maker, self.region, self.grape, self.link, self.price_club, 
      self.price_regular, self.price_sale, self.site_sku, self.global_id] 
    begin
      conn.prepare('save', sql) # values must match the same order as sql statement
      conn.exec_prepared('save', values) # this method requires an array as second argument
      conn.close
    rescue # StandardError => e # if it alreay exists, we are going to update it
      conn.close
      #update # is it right to use the begin/rescue structure for it?
    end
  end

  def update
    table_name = "wine_site"
    conn = PG.connect(host: 'localhost', password: 'admin', user: 'postgres', dbname: 'webwiner')
    values = [self.year, self.name, self.maker, self.region, self.grape, self.link, self.price_club, 
      self.price_regular, self.price_sale, self.site_sku, self.global_id] 
    sql = " UPDATE #{table_name} SET (year, name, maker, region, grape, link, price_club, price_regular, price_sale, site_sku) =
    ( $1, $2, $3, $4, $5, $6, $7, $8, $9, $10) WHERE global_id = $11 "
    conn.prepare('save', sql)
    conn.exec_prepared('save', values)
    conn.close
  end


end
