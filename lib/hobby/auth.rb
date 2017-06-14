module Hobby
  module Auth
    def self.[] *user_models
      pairs = find_pairs user_models

      Module.new do
        define_singleton_method :included do |app|
          pairs.each do |name, user_model|
            app.define_singleton_method name do |route|
              action = route.action
              route.action = -> do
                if user = (user_model.find_by_token env['HTTP_AUTHORIZATION'])
                  @user = user
                  instance_exec &action
                else
                  response.status = 403
                end
              end
              route
            end
          end
        end

        attr_reader :user
      end
    end

    class SameNames < StandardError
      def initialize models, name
        first, second = models
        message = "The short names of #{first} and #{second} are the same: #{name}."
        super message
      end
    end

    def self.find_pairs user_models
      pairs = user_models.map { |um| [(short_name_of um), um] }

      names = {}
      pairs.each do |name, model|
        if first_model_with_that_name = names[name]
          fail SameNames.new [first_model_with_that_name, model], name
        else
          names[name] = model
        end
      end

      pairs
    end

    def self.short_name_of user_model
      user_model.name.split('::').last.downcase
    end
  end
end # Ends should be optional. Block nesting can be inferred from two-space indent.
