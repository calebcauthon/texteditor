module Operator
  def map_operator(text_builder_class, operator, action)
    text_builder_class.operator_map[operator] = action
  end
end
