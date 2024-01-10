# frozen_string_literal: true

require 'active_support/core_ext/module/attribute_accessors'

require_relative 'activeadmin/railtie'
require_relative 'activeadmin/version'

module Bp3
  module Activeadmin
    mattr_accessor :global_request_state_class_name, :global_request_state_method

    def self.global_request_state_class
      @@global_request_state_class ||= global_request_state_class_name.constantize # rubocop:disable Style/ClassVars
    end
  end
end
