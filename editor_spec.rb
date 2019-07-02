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
      expect(result).to eq("1")
    end

    it 'interprets "1" as append and returns "test-2"' do
      instructions = <<~HEREDOC
        2
        1 test-2
        3 6
      HEREDOC
      result = text_editor(instructions)
      expect(result).to eq("2")
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
      expect(result).to eq("a")
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
        expect(result).to eq("J")
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
      expected_result = "B"
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
      expected_result = "t\na\ni\nl"
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
      expected_result = "t\no\nt"
      expect(result).to eq(expected_result)
    end

    it 'can be reversed' do
      instructions = <<~HEREDOC
        7
        1 pop
        5 p t
        4
        3 1
        3 2
        3 3
      HEREDOC

      result = text_editor(instructions)
      expected_result = "p\no\np"
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
      expected_result = "c\ny\na"
      expect(result).to eq(expected_result)
    end

    it 'test case 1 from hackerrank' do
      instructions = <<~HEREDOC
        10
        1 ewcgpjfh
        1 igqsbqyp
        1 qsdliigcj
        4
        3 15
        1 iilmgp
        2 8
        4
        2 18
        1 scwhors
      HEREDOC

      result = text_editor(instructions)
      expected_result = "y"
      expect(result).to eq(expected_result)
    end

    # it 'handles the 1M instructions from hackerrank test case 10' do
    #   instructions = File.read('./spec/test_cases/test_case_10/input.txt')
    #   expected_result = File.read('./spec/test_cases/test_case_10/output.txt')
    #   result = text_editor(instructions)
    #   compare_by_scanning_every(250, result, expected_result)
    # end

    # it 'test case 3 from hackerrank' do
    #   instructions = File.read('./spec/test_cases/test_case_3/input.txt')
    #   expected_result = File.read('./spec/test_cases/test_case_3/output.txt')
    #   result = text_editor(instructions)
    #   expect(result).to eq(expected_result)
    # end

    # it 'test case 11 from hackerrank' do
    #   instructions = File.read('./spec/test_cases/test_case_11/input.txt')
    #   expected_result = File.read('./spec/test_cases/test_case_11/output.txt')
    #   result = text_editor(instructions)
    #   expect(result.size).to eq(expected_result.size)

    #   compare_by_scanning_every(300, result, expected_result)
    # end
  end
end

def compare_by_scanning_every(character_interval, text1, text2)
  increments = text1.size / character_interval
  (0..increments).map { |n| n * character_interval - 1 }.each do |index|
    expect(text1[index]).to eq(text2[index])
  end
end
