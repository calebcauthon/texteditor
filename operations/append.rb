require_relative './operator'

module Append
  extend Operator

  def append text
    set_new_text_state "#{@current_text}#{text}"
    return
  end

  def reverse_append character_count
    @current_text = @current_text[0...(-1 * character_count)]
    return
  end

  def self.included(base)
    self.map_operator base, :append, lambda { |builder, instruction| builder.append instruction.operand }
    self.map_operator base, :reverse_append, lambda { |builder, instruction| builder.reverse_append instruction.operand.operand.size }
  end
end
