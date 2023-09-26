# frozen_string_literal: true

require_relative './board'
require_relative './display'
require_relative './engine'

require_relative './players/human'
require_relative './players/computer'

require 'rainbow'

class Game
  def initialize
    @players = [Human.new(:w), Human.new(:b)]
    @engine = Engine.new
    @turn_counter = 0
  end

  def all_pieces
    @players[0].pieces.union(@players[1].pieces)
  end

  def create_players
    system('clear')

    @players.each_with_index do |player, _i|
      # player.get_name(i + 1)
      player.create_pieces
    end
  end

  def update_all_pieces
    @players.each do |player|
      @engine.update_player_moves(player, all_pieces)
    end
  end

  def play
    loop do
      update_all_pieces

      temp = if @turn_counter.even?
               prepare(@players[0], @players[1])
             else
               prepare(@players[1], @players[0])
             end

      return temp unless temp.nil?

      @turn_counter += 1
    end
  end

  def prepare(player, enemy)
    enemy = @engine.filter_moves(player, enemy, all_pieces)

    game_status = game_over?(player, enemy)

    return game_status unless game_status == false

    play_turn(player, enemy)

    nil
  end

  def play_turn(player, enemy)
    move = ''

    loop do
      @engine.create_board(player, enemy, all_pieces)

      piece = get_valid_piece(player)

      @engine.create_board(player, enemy, all_pieces, piece)

      move = get_valid_move(player, piece)

      break unless move == false
    end

    @engine.update_pieces(player, enemy, piece, move)

    @engine.update_counters(all_pieces)
  end

  def get_valid_piece(player)
    # save
    loop do
      choice = player.get_choice(1)

      coord = [choice[0].ord - 96, choice[1].to_i]

      player.pieces.each { |piece| return piece if piece.coordinates == coord && !piece.moves.empty? }

      puts Rainbow("Invalid piece: tile is empty or piece can't move!").color(:red)
    end
  end

  def get_valid_move(player, piece)
    loop do
      choice = player.get_choice(2)

      return false if choice == 'back'

      coord = [choice[0].ord - 96, choice[1].to_i]

      return coord if piece.moves.include?(coord)

      puts Rainbow('Invalid move!').color(:red)
    end
  end

  def game_over?(player, enemy)
    return 'CM' if @engine.checkmate?(player, enemy)

    return 'SM' if @engine.stalemate?(player, enemy)

    return 'DP' if @engine.dead_position?(all_pieces)

    return 'FFR' if @engine.fivefold_repetition?(all_pieces)

    return '75' if @engine.seventy_five_move_rule?

    false
  end
end

game = Game.new
game.create_players
p game.play
