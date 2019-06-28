require 'require_all'
require_all './operations'
require './text_builder/text_builder'

def text_editor instruction_text
  text_state = TextBuilder.new
  instructions = InstructionParser.new
  instructions.load instruction_text

  output = ''

  instructions.each do |instruction|
    new_output = text_state.operate instruction
    output = "#{output}#{new_output}"
  end

  output
end
