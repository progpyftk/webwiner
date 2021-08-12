require 'pg'
# connect to the "master-db" called 'postgres'

def db_exists?(name)
    PG.connect :dbname => 'nonex', :user => 'postgres', :password =>'admin'
rescue PG::ConnectionBad => e # this is how it uses the constant
    puts e
    false 
end
