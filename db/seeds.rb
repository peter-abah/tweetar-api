# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require_relative './seeds/seed_tweets'
require_relative './seeds/seed_users'
require_relative './seeds/seed_followers'
require_relative './seeds/seed_retweets'
require_relative './seeds/seed_likes'
require_relative './seeds/seed_replies'

puts 'STARTING SEEDING...'

puts 'SEEDING USERS...'
seed_users
puts 'SEEDING USERS COMPLETE'

puts 'SEEDING FOLLOWERS...'
seed_followers
puts 'SEEDING FOLLOWERS COMPLETE'

puts 'SEEDING TWEETS...'
seed_tweets
puts 'SEEDING TWEETS COMPLETE'

puts 'SEEDING REPLIES...'
seed_replies
puts 'SEEDING REPLIES COMPLETE'

puts 'SEEDING RETWEETS...'
seed_retweets
puts 'SEEDING RETWEETS COMPLETE'

puts 'SEEDING LIKES...'
seed_likes
puts 'SEEDING LIKES COMPLETE'

puts 'SEEDING COMPLETE'
