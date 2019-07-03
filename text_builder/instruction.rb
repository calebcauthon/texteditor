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
      @operation_class = Write.new
    when '2'
      @operation = :delete
      @operation_class = Delete.new
    when '1'
      @operation = :append
      @operation_class = Append.new
    when '5'
      @operation = :replace
      @operation_class = Replace.new
    end

    @operand = instruction_line.slice(2..instruction_line.size-1)
    @raw = instruction_line
  end

  def disable_reversal
    @reverse_disabled = true
  end

  def reverse current_text
    return if @reverse_disabled

    reverse_name = "reverse_#{@operation.to_s}".to_sym

    if @operation_class.is_reversible?
      instruction = Instruction.new
      instruction.operation_class = self.operation_class.undo
      instruction.operand = self
      instruction
    end
  end
end
