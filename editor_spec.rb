require_relative 'editor'

describe 'text editor' do
  describe 'single instructions' do
    it 'returns a blank string if there are no instructions' do
      instructions = <<~HEREDOC
        0
      HEREDOC
      result = text_editor(instructions)
      expect(result).to eq('')
    end

    it 'interprets "1" as append and returns "test-1"' do
      instructions = <<~HEREDOC
        1
        1 test-1
      HEREDOC
      result = text_editor(instructions)
      expect(result).to eq('test-1')
    end

    it 'interprets "1" as append and returns "test-2"' do
      instructions = <<~HEREDOC
        1
        1 test-2
      HEREDOC
      result = text_editor(instructions)
      expect(result).to eq('test-2')
    end
  end

  describe 'multiple instructions' do
    it 'appends multiple strings together when there are 2 append commands' do
      instructions = <<~HEREDOC
        2
        1 Jan
        2 uary
      HEREDOC

      result = text_editor(instructions)
      expect(result).to eq('January')
    end
  end
end
