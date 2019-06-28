require_relative './operator'

module Append
  extend Operator

  def append text
    set_new_text_state "#{@current_text}#{text}"
    return
  end

  def self.included(base)
    self.map_operator base, :append, lambda { |builder, instruction| builder.append instruction.operand }
  end
end
