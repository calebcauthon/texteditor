class Instruction
  attr_accessor :operation
  attr_accessor :operand
  attr_accessor :raw

  def load_from_text(instruction_line)
    operator = instruction_line.slice(0)

    case operator
    when '4'
      @operation = Undo.new
    when '3'
      @operation = Write.new
    when '2'
      @operation = Delete.new
    when '1'
      @operation = Append.new
    when '5'
      @operation = Replace.new
    end

    @operand = instruction_line.slice(2..instruction_line.size-1)
    @raw = instruction_line
  end

  def reverse current_text
    instruction = Instruction.new
    instruction.operation = self.operation.undo
    instruction.operand = self
    instruction
  end
end
