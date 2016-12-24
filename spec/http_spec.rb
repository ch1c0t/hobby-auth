require 'helper'

require_relative 'seed_users'

Hobby::Devtools::RSpec.describe do
  app do
    Class.new do
      include Hobby
      include Hobby::Auth[Getter, Poster]

      getter get { 'oh my get' }
      poster post { "the user's token is #{user.token}" }
    end.new
  end
  path 'spec/http/**/*.yml'
end