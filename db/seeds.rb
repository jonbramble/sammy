# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.delete_all

seed_file = File.join(Rails.root, 'db', 'users.yml')
config = YAML::load(ERB.new(File.read(seed_file)).result)

config['users'].each do |user|
 u = User.new(user)
 u.save!
end
