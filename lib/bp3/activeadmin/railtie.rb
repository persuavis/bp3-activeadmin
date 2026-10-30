# frozen_string_literal: true

require 'active_support'
require 'rails/railtie'

module Bp3
  module Activeadmin
    class Railtie < Rails::Railtie
      initializer 'bp3.activeadmin.railtie.register' do |app|
        app.config.after_initialize do
          ::ActiveAdmin::Filters # preload
          ::ActiveAdmin::Comment # preload
          module ::ActiveAdmin
            module Filters
              # PrependResourceExtension ensures that the default_filters honor the ransackable attributes
              module PrependResourceExtension
                def default_filters
                  filters = super
                  allowed = resource_class.ransackable_fields(auth_object)
                  filters & allowed
                end

                def auth_object
                  Bp3::Activeadmin.global_request_state_class.send(Bp3::Activeadmin.global_request_state_method)
                end
              end

              module ResourceExtension
                prepend PrependResourceExtension
              end
            end

            class Comment
              include Bp3::Core::Ransackable

              # ActiveAdmin defines these on the class itself, which beats anything included, so its
              # answers stand only for plain ransack and Ransackable still answers EXPLORE
              def self.ransackable_attributes(auth_object = nil)
                return super if auth_object == Bp3::Core::Ransackable::EXPLORE

                authorizable_ransackable_attributes
              end

              def self.ransackable_associations(auth_object = nil)
                return super if auth_object == Bp3::Core::Ransackable::EXPLORE

                authorizable_ransackable_associations
              end
            end
          end
        end
      end
    end
  end
end
