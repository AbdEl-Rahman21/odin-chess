# frozen_string_literal: true

module Display
  def game_selection
    system('clear')

    puts <<~HEREDOC
      Select one of the following:-
      [1] New game
      [2] Load a saved game
    HEREDOC
  end

  def player_selection
    system('clear')

    puts <<~HEREDOC
      Select one of the following:-
      [1] Human vs. Human
      [2] Human vs. Computer
      [3] Computer vs. Human
      [4] Computer vs. Computer
    HEREDOC
  end
end
