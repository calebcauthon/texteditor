def text_editor instructions
  text_state = TextBuilder.new
  instruction_lines = instructions.split(/\n/)
  first_line = instruction_lines.first

  output = ''
  if instruction_lines.size > 1

    instruction_lines.slice(1..instruction_lines.size-1).each do |instruction_line|
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
  end

  output
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