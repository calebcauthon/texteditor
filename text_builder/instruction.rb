class Instruction
  attr_accessor :operation
  attr_accessor :operation_class
  attr_accessor :operand
  attr_accessor :raw

  def load_from_text instruction_line
    operator = instruction_line.slice(0)

    case operator
    when '4'
      @operation = :undo
    when '3'
      @operation = :print
      @operation_class = Print.new
    when '2'
      @operation = :delete
      @operation_class = Delete.new
    when '1'
      @operation = :append
    when '5'
      @operation = :replace
    end

    @operand = instruction_line.slice(2..instruction_line.size-1)
    @raw = instruction_line
  end

  def disable_reversal
    @reverse_disabled = true
  end

  def reverse current_text
    return if @reverse_disabled

    instruction = Instruction.new
    instruction.operation = "reverse_#{@operation.to_s}".to_sym
    instruction.operand = self
    instruction.disable_reversal
    instruction
  end
end
