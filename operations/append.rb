require_relative './operator'

module Append
  extend Operator

  def append text
    @previous_states.push @current_text
    @current_text = "#{@current_text}#{text}"

    return
  end

  def self.included(base)
    self.map_operator base, :append, lambda { |builder, instruction| builder.append instruction.operand }
  end
end
