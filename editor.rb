def text_editor instructions
  instruction_lines = instructions.split(/\n/)
  first_line = instruction_lines.first

  text = ''
  if instruction_lines.size > 1

    instruction_lines.slice(1..instruction_lines.size-1).each do |instruction_line|
      operation = instruction_line.slice(1)
      text = "#{text}#{instruction_line.slice(2..instruction_line.size-1)}"
    end
  end

  text
end