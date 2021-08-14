# frozen_string_literal: true

module DBTable
  def self.create(database)
    conn = PG.connect(host: 'localhost', password: 'admin', user: 'postgres', dbname: database)
    begin
      conn.exec("
            CREATE TABLE IF NOT EXISTS wine_site
            (year integer, name VARCHAR(255), maker VARCHAR(255), region VARCHAR(255), grape VARCHAR(255),
            link VARCHAR(255), price_club VARCHAR(255), price_regular VARCHAR(255), price_sale VARCHAR(255), site_sku VARCHAR(255),
            store VARCHAR(255), global_id VARCHAR(255) PRIMARY KEY )")

      conn.exec("
            CREATE TABLE IF NOT EXISTS evino_site
            (year integer ,name VARCHAR(255), maker VARCHAR(255), region VARCHAR(255),
            grape VARCHAR(255), link VARCHAR(255), price_club VARCHAR(255), price_regular VARCHAR(255),
            price_sale VARCHAR(255), site_sku VARCHAR(255), global_id VARCHAR(255))")

      conn.exec("
            CREATE TABLE IF NOT EXISTS same_wines
            ( global_id_wine VARCHAR(255), global_id_evino VARCHAR(255))")

      conn.exec("
            CREATE TABLE IF NOT EXISTS price_history_wine
            (global_id VARCHAR(255), price_club FLOAT, price_regular FLOAT,
            price_sale FLOAT, date DATE )")

      conn.exec("
            CREATE TABLE IF NOT EXISTS price_history_evino
            (global_id VARCHAR(255), price_regular FLOAT, price_sale FLOAT, date DATE)")
    rescue StandardError => e
      e
    end
    conn.close
  end

  def self.delete(table_name, database)
    conn = PG.connect(host: 'localhost', password: 'admin', user: 'postgres', dbname: database)
    sql = "DROP TABLE IF EXISTS #{table_name}"
    conn.exec(sql)
    conn.close
  end
end
