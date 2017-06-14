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
    end

    def self.find_pairs user_models
      array = user_models.map { |um| [(short_name_of um), um] }

      names = array.map &:first
      unless names.size == names.uniq.size
        fail SameNames
      end

      array.to_h
    end

    def self.short_name_of user_model
      user_model.name.split('::').last.downcase
    end
  end
end # Ends should be optional. Block nesting can be inferred from two-space indent.
