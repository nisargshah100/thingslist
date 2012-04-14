require 'csv'

PATH = './db/data'

def cleanup(name)
  name.gsub("_", " ").downcase
end

categories_data = File.read("#{PATH}/categories.yml")
categories = YAML::load(categories_data)

count = 0
categories.each do |k,v|
  main = Category.create!(:name => cleanup(k))
  count += 1

  v.each do |category|
    Category.create!(:name => cleanup(category), :parent => main)
    count += 1
  end
end

puts "Saved Categories (#{count})"

count = 0
states_data = File.read("#{PATH}/states.csv")

csv = CSV.parse(states_data, :headers => true)
csv.each do |row|
  row = row.to_hash.with_indifferent_access
  State.create!(row.to_hash.symbolize_keys)
  count += 1
end

puts "Saved States (#{count})"

count = 0
cities_data = File.read("#{PATH}/cities.csv")

states = {}
cities = []
State.all.each { |s| states[s[:abbr]] = s.id }

csv = CSV.parse(cities_data, :headers => true, :header_converters => :symbol)
csv.each do |row|
  name = cleanup(row[:name])
  state = states[row[:abbr]]

  if name and state
    cities << {
      :name => name, 
      :state_id => state, 
      :source => [row[:lng].to_f, row[:lat].to_f]
    }
  end
end

City.collection.insert(cities)

# City.all.each do |c|
#   c.source = { :lng => c.source[0], :lat => c.source[1] }
#   c.save()
# end

puts "Cities Saved (#{City.count})"
system "rake db:mongoid:create_indexes"

puts "Updating Indexes"
City.update_ngram_index
puts "DONE!"