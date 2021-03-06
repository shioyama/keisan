module Keisan
  module Variables
    class DefaultRegistry < Registry
      def initialize
        @hash = {}
        @parent = self.class.registry
      end

      VARIABLES = {
        "PI" => Math::PI,
        "E" => Math::E,
        "I" => Complex(0,1)
      }

      def self.registry
        @registry ||= Registry.new(variables: VARIABLES, parent: nil, force: true).freeze
      end
    end
  end
end
