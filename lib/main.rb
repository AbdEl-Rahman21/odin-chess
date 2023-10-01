# frozen_string_literal: true

require 'rainbow'
require 'fileutils'
require 'yaml'

require_relative './game'

def start
  loop do
    game = nil

    while game.nil?
      if game_selection == '1'
        game = Game.new(player_selection)

        game.create_players
      else
        game = load_game
      end
    end

    game.play

    end_game(game)

    print 'Play again? [Y] for yes any other symbol for no: '

    break unless gets.chomp.downcase == 'y'
  end
end

def game_selection
  system('clear')

  puts <<~HEREDOC
    Select one of the following:-
    [1] New game
    [2] Load a saved game

  HEREDOC

  choice = ''

  loop do
    print 'Enter your choice: '

    choice = gets.chomp

    break if %w[1 2].include?(choice)

    puts Rainbow('Invalid choice!').color(:red)
  end

  choice
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

  choice = ''

  loop do
    print 'Enter your choice: '

    choice = gets.chomp

    break if %w[1 2 3 4].include?(choice)

    puts Rainbow('Invalid choice!').color(:red)
  end

  assign_players(choice)
end

def assign_players(choice)
  case choice
  when '1'
    [Human.new(:w), Human.new(:b)]
  when '2'
    [Human.new(:w), Computer.new(:b)]
  when '3'
    [Computer.new(:w), Human.new(:b)]
  when '4'
    [Computer.new(:w), Computer.new(:b)]
  end
end

def load_game
  system('clear')

  saves = Dir.glob('saved_games/*.yaml')

  if saves.empty?
    puts Rainbow('Error: No saves to load').color(:red)

    sleep(5)

    return nil
  end

  saves.each_with_index { |save, i| puts "[#{i + 1}] #{save[12..-6]}" }

  YAML.load_file(
    get_save_to_load(saves).to_s,
    aliases: true,
    permitted_classes: [Symbol, Bishop, King, Knight, Pawn, Piece, Queen, Rook, Computer, Human, Player, Board, Engine,
                        Game]
  )
end

def get_save_to_load(saves)
  loop do
    print 'Enter save name: '

    choice = gets.chomp.to_i

    return saves[choice - 1] if choice.positive? && choice <= saves.length

    puts Rainbow('Invalid choice!').color(:red)
  end
end

def end_game(game)
  case game.state
  when 'resign'
    if game.players[0].color == :w
      puts Rainbow('White Resigned: 0 - 1').color(:green)
    else
      puts Rainbow('Black Resigned: 1 - 0').color(:green)
    end
  when 'CM'
    if game.players[1].color == :w
      puts Rainbow('Checkmate: 1 - 0').color(:green)
    else
      puts Rainbow('Checkmate: 0 - 1').color(:green)
    end
  when 'SM'
    puts Rainbow('Stalemate: 1/2 - 1/2').color(:blue)
  when 'DP'
    puts Rainbow('Dead Position: 1/2 - 1/2').color(:blue)
  when 'FFR'
    puts Rainbow('Fivefold Repetition: 1/2 - 1/2').color(:blue)
  when '75'
    puts Rainbow('Seventy-Five-Move: 1/2 - 1/2').color(:blue)
  when 'save'
    save_game(game)
  end
end

def save_game(game)
  FileUtils.mkdir_p('saved_games')

  game.state = nil

  File.open("saved_games/#{get_save_name}.yaml", 'w') { |file| file.puts YAML.dump(game) }
end

def get_save_name
  loop do
    print 'Enter save name: '

    save_name = gets.chomp

    return save_name unless File.exist?("saved_games/#{save_name}.yaml")

    print 'Name is taken, do you want to override it (Y) for yes: '

    return save_name if gets.chomp.downcase == 'y'
  end
end

start
