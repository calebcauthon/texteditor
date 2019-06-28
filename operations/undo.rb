require_relative './operator'

module Undo
  extend Operator
  @@action = :undo

  def undo
    @current_text = @previous_states.pop
    return
  end

  def self.included(base)
    self.map_operator base, @@action, lambda { |builder, instruction| builder.undo }
  end
end
