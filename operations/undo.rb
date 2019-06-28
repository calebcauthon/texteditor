require_relative './operator'

module Undo
  extend Operator
  @@action = :undo

  def undo
    @current_text = @previous_states.pop
    return
  end

  def previous_states
    @previous_states = [] unless @previous_states
    @previous_states
  end

  def self.included(base)
    self.map_operator base, @@action, lambda { |builder, instruction| builder.undo }
    hook = lambda { |builder, text| builder.previous_states.push builder.current_text }
    base.on_before_new_text_state.push hook
  end
end
