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
        2
        1 test-1
        3 6
      HEREDOC
      result = text_editor(instructions)
      expect(result).to eq("1\n")
    end

    it 'interprets "1" as append and returns "test-2"' do
      instructions = <<~HEREDOC
        2
        1 test-2
        3 6
      HEREDOC
      result = text_editor(instructions)
      expect(result).to eq("2\n")
    end
  end

  describe 'multiple instructions' do
    it 'appends multiple strings together when there are 2 append commands' do
      instructions = <<~HEREDOC
        2
        1 Jan
        1 uary
        3 5
      HEREDOC

      result = text_editor(instructions)
      expect(result).to eq("a\n")
    end
  end

  describe 'undo' do
    describe 'append' do
      it 'reverts the last append' do
        instructions = <<~HEREDOC
          3
          1 Snake
          1 Oil
          4
          1 Juice
          3 6
        HEREDOC

        result = text_editor(instructions)
        expect(result).to eq("J\n")
      end
    end
  end

  describe 'print' do
    it 'includes the correct character in the output' do
      instructions = <<~HEREDOC
        2
        1 ABCD
        3 2
      HEREDOC

      result = text_editor(instructions)
      expected_result = <<~HEREDOC
        B
      HEREDOC
      expect(result).to eq(expected_result)
    end
  end

  describe 'delete' do
    it 'removes the correct last number of characters' do
      instructions = <<~HEREDOC
        7
        1 dogfood
        2 4
        1 tail
        3 4
        3 5
        3 6
        3 7
      HEREDOC

      result = text_editor(instructions)
      expected_result = <<~HEREDOC
        t
        a
        i
        l
      HEREDOC
      expect(result).to eq(expected_result)
    end
  end

  describe 'replace' do
    it 'replaces all instances of one character with another' do
      instructions = <<~HEREDOC
        7
        1 pop
        5 p t
        3 1
        3 2
        3 3
      HEREDOC

      result = text_editor(instructions)
      expected_result = <<~HEREDOC
        t
        o
        t
      HEREDOC
      expect(result).to eq(expected_result)
    end
  end

  describe 'mix of all operations' do
    it 'returns c/y/a' do
      instructions = <<~HEREDOC
        8
        1 abc
        3 3
        2 3
        1 xy
        3 2
        4 
        4 
        3 1
      HEREDOC

      result = text_editor(instructions)
      expected_result = <<~HEREDOC
        c
        y
        a
      HEREDOC
      expect(result).to eq(expected_result)
    end
  end
end
