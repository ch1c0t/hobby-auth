require 'helper'

require_relative 'seed_users'

Hobby::Devtools::RSpec.describe do
  app do
    Class.new do
      include Hobby
      include Hobby::Auth[Getter, Namespaced::Poster]

      Getter get { 'oh my get' }
      Poster post { "the user's token is #{user.token}" }


      def self.append_decorator route
        action = route.action
        route.action = -> { "#{instance_exec(&action)} append" }
        route
      end

      append_decorator Getter get('/decorator') { 'decorator' }
    end.new
  end
end
