class Instruction
  attr_accessor :operation
  attr_accessor :operand

  def initialize instruction_line
    operator = instruction_line.slice(0)

    case operator
    when '4'
      @operation = :undo
    when '3'
      @operation = :print
    when '2'
      @operation = :delete
    when '1'
      @operation = :append
    when '5'
      @operation = :replace
    end

    @operand = instruction_line.slice(2..instruction_line.size-1)
  end

  def disable_reversal
    @reverse_disabled = true
  end

  def reverse current_text
    return nil if @reverse_disabled

    if @operation == :replace
      instruction = Instruction.new "5 #{self.operand.reverse}"
      instruction.disable_reversal
      instruction
    elsif @operation == :append
      instruction = Instruction.new "2 #{self.operand.size}"
      instruction.disable_reversal
      instruction
    elsif @operation == :delete
      characters_to_add_back = current_text[current_text.size-1-self.operand.size-1..current_text.size-1]
      instruction = Instruction.new "1 #{characters_to_add_back}"
      instruction.disable_reversal
      instruction
    end
  end
end
