module Hobby
  module Auth
    def self.[] *users
      Module.new do
        define_singleton_method :included do |app|
          users.each do |user|
            app.define_singleton_method user.name.downcase do |route|
              action = route.action
              route.action = -> do
                if user = (user.find_by_token request.get_header 'Authorization')
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
