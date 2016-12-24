module Hobby
  module Auth
    def self.[] *user_models
      Module.new do
        define_singleton_method :included do |app|
          user_models.each do |user_model|
            app.define_singleton_method user_model.name.downcase do |route|
              action = route.action
              route.action = -> do
                if user = (user_model.find_by_token env['HTTP_AUTHORIZATION'])
                  instance_exec &action
                else
                  response.status = 403
                end
              end
              route
            end
          end
        end
      end
    end
  end
end # Ends should be optional. Block nesting can be inferred from two-space indent.
