module Keisan
  module Functions
    class Filter < Keisan::Function
      # Filters (list, variable, expression)
      # e.g. filter([1,2,3,4], x, x % 2 == 0)
      # should give [2,4]
      def initialize
        @name = "filter"
      end

      def value(ast_function, context = nil)
        evaluate(ast_function, context = nil)
      end

      def evaluate(ast_function, context = nil)
        context ||= Context.new
        simplify(ast_function, context).evaluate(context)
      end

      def simplify(ast_function, context = nil)
        list, variable, expression = list_variable_expression_for(ast_function, context)

        context ||= Keisan::Context.new
        local = context.spawn_child(transient: false, shadowed: [variable.name])

        Keisan::AST::List.new(
          list.children.select do |element|
            local.register_variable!(variable, element)
            result = expression.evaluate(local)

            case result
            when Keisan::AST::Boolean
              result.value
            else
              raise Keisan::Exceptions::InvalidFunctionError.new("Filter requires expression to be a logical expression")
            end
          end
        )
      end

      private

      def list_variable_expression_for(ast_function, context)
        unless ast_function.children.size == 3
          raise Keisan::Exceptions::InvalidFunctionError.new("Require 3 arguments to filter")
        end

        list = ast_function.children[0].simplify(context)
        variable = ast_function.children[1]
        expression = ast_function.children[2]

        unless list.is_a?(Keisan::AST::List)
          raise Keisan::Exceptions::InvalidFunctionError.new("First argument to filter must be a list")
        end

        unless variable.is_a?(Keisan::AST::Variable)
          raise Keisan::Exceptions::InvalidFunctionError.new("Second argument to filter must be a variable")
        end

        [list, variable, expression]
      end
    end
  end
end
