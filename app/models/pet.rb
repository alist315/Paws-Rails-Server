class Pet
  if(ENV['DATABASE_URL'])
          uri = URI.parse(ENV['DATABASE_URL'])
          DB = PG.connect(uri.hostname, uri.port, nil, nil, uri.path[1..-1], uri.user, uri.password)
      else
          DB = PG.connect(host: "localhost", port: 5432, dbname: 'paws_and_found_development')
      end

def self.all
    results = DB.exec("SELECT * FROM pets;")
    return results.map do |result|
      if result["found"] === 'f'
        {
            "id" => result["id"].to_i,
            "name" => result["name"],
            "species" => result["species"],
            "breed" => result["breed"],
            "photo" => result["photo"],
            "last_known_location" => result["last_known_location"],
            "description" => result["description"],
            "found" => false
        }
     else
       {
           "id" => result["id"].to_i,
           "name" => result["name"],
           "species" => result["species"],
           "breed" => result["breed"],
           "photo" => result["photo"],
           "last_known_location" => result["last_known_location"],
           "description" => result["description"],
           "found" => true
       }
     end

    end
end

def self.find(id)
    results = DB.exec("SELECT * FROM pets WHERE id=#{id};")
    if results.first["found"] === 'f'
    return {
      "id" => results.first["id"].to_i,
      "name" => results.first["name"],
      "species" => results.first["species"],
      "breed" => results.first["breed"],
      "photo" => results.first["photo"],
      "last_known_location" => results.first["last_known_location"],
      "description" => results.first["description"],
      "found" => false
    }
  else
    {
      "id" => results.first["id"].to_i,
      "name" => results.first["name"],
      "species" => results.first["species"],
      "breed" => results.first["breed"],
      "photo" => results.first["photo"],
      "last_known_location" => results.first["last_known_location"],
      "description" => results.first["description"],
      "found" => true
    }
  end
end

def self.create(opts)
  p 'inside create method'
  p opts
    results = DB.exec(
        <<-SQL
            INSERT INTO pets (name, species, breed, photo, last_known_location, description, found)
            VALUES ('#{opts["name"]}', '#{opts["species"]}', '#{opts["breed"]}', '#{opts["photo"]}', '#{opts["last_known_location"]}', '#{opts["description"]}', '#{opts["found"]}')
            RETURNING id, name, species, breed, photo, last_known_location, description, found;
        SQL
    )
    return {
      "id" => results.first["id"].to_i,
      "name" => results.first["name"],
      "species" => results.first["species"],
      "breed" => results.first["breed"],
      "photo" => results.first["photo"],
      "last_known_location" => results.first["last_known_location"],
      "description" => results.first["description"],
      "found" => results.first["found"]
    }
end

def self.delete(id)
    results = DB.exec("DELETE FROM pets WHERE id=#{id};")
    return { "deleted" => true }
end

def self.update(id, opts)
    results = DB.exec(
        <<-SQL
            UPDATE pets
            SET name='#{opts["name"]}', species='#{opts["species"]}', breed='#{opts["breed"]}', photo='#{opts["photo"]}', last_known_location='#{opts["last_known_location"]}', description='#{opts["description"]}', found='#{opts["found"]}'
            WHERE id=#{id}
            RETURNING id, name, species, breed, photo, last_known_location, description, found;
        SQL
    )
    return {
      "id" => results.first["id"].to_i,
      "name" => results.first["name"],
      "species" => results.first["species"],
      "breed" => results.first["breed"],
      "photo" => results.first["photo"],
      "last_known_location" => results.first["last_known_location"],
      "description" => results.first["description"],
      "found" => results.first["found"]
    }
end
end
