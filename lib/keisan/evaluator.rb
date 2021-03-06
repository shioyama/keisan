module Keisan
  class Evaluator
    attr_reader :calculator

    def initialize(calculator)
      @calculator = calculator
    end

    def evaluate(expression, definitions = {})
      context = calculator.context.spawn_child(definitions: definitions, transient: true)
      ast = Keisan::AST.parse(expression)
      evaluation = ast.evaluate(context)

      case ast
      when Keisan::AST::Assignment
        if ast.children.first.is_a?(Keisan::AST::Variable)
          context.variable(ast.children.first.name).value(context)
        end
      else
        evaluation.value(context)
      end
    end

    def simplify(expression, definitions = {})
      context = calculator.context.spawn_child(definitions: definitions, transient: true)
      ast = Keisan::AST.parse(expression)
      ast.simplify(context)
    end

    def ast(expression)
      Keisan::AST.parse(expression)
    end
  end
end
