module Compute
  module AST
    class LogicalOperator < Operator
      def associativity
        :left
      end
    end
  end
end