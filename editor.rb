def text_editor instruction_text
  text_state = TextBuilder.new
  instructions = Instructions.new
  instructions.load instruction_text

  output = ''

  instructions.each do |instruction_line|
    operation = instruction_line.slice(0)
    if operation == '4'
      text_state.undo
    elsif operation == '3'
      character_index = instruction_line.slice(2..instruction_line.size-1)
      character = text_state.get_character character_index
      output = "#{output}#{character}\n"
    else
      text_to_append = instruction_line.slice(2..instruction_line.size-1)
      text_state.append text_to_append
    end
  end

  output
end

class Instructions
  def load text
    all_lines = text.split(/\n/)
    @instruction_lines = all_lines.slice(1..all_lines.size-1)
    @index = 0
  end

  def each
    return nil unless @instruction_lines.at(@index)

    @instruction_lines.each do |line|
      yield line
    end
  end
end

class TextBuilder
  def initialize
    @current_text = ''
    @previous_states = []
  end

  def append text
    @previous_states.push @current_text
    @current_text = "#{@current_text}#{text}"
  end

  def current_text
    @current_text
  end

  def undo
    @current_text = @previous_states.pop
  end

  def get_character character_index
    @current_text[character_index.to_i-1]
  end
end