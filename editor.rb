require 'require_all'
require_all './operations'
require './text_builder/text_builder'

def text_editor(instruction_text)
  text_state = TextBuilder.new
  instructions = InstructionParser.new
  instructions.load(instruction_text)

  instructions.instruction_lines.inject '' do |output, instruction_text|
    instruction = Instruction.new
    instruction.load_from_text instruction_text

    new_output = text_state.operate instruction

    append_to_output(output, new_output)
  end
end

def append_to_output(output, new_output)
  if output.size > 0 && new_output && new_output.size > 0
    output << "\n#{new_output}"
  elsif output == '' && new_output && new_output.size > 0
    output = new_output
  end

  output
end
