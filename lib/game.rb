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

  def update_all_moves
    @players.each do |player|
      @engine.update_player_moves(player, all_pieces)
    end

    @players.each do |player|
      player.pieces.last.castling(all_pieces)
    end
  end

  def play
    loop do
      update_all_moves

      turn_order

      temp = prepare

      return temp unless temp.nil?

      @turn_counter += 1
    end
  end

  def turn_order
    @players.reverse! if (@turn_counter.even? && @players[0].color == :b) ||
                         (@turn_counter.odd? && @players[0].color == :w)
  end

  def prepare
    @engine.filter_moves(@players[0], @players[1], all_pieces)

    game_status = game_over?

    return game_status unless game_status == false

    play_turn

    nil
  end

  def play_turn
    move = ''
    piece = 0

    loop do
      @engine.create_board(@players[0], @players[1], all_pieces)

      piece = get_valid_piece

      @engine.create_board(@players[0], @players[1], all_pieces, piece)

      move = get_valid_move(piece)

      break unless move == false
    end

    @engine.update_pieces(@players[0], @players[1], piece, move)

    @engine.update_counters(all_pieces)
  end

  def get_valid_piece
    # save
    loop do
      choice = @players[0].get_choice(1)

      coord = [choice[0].ord - 96, choice[1].to_i]

      @players[0].pieces.each { |piece| return piece if piece.coordinates == coord && !piece.moves.empty? }

      puts Rainbow("Invalid piece: tile is empty or piece can't move!").color(:red)
    end
  end

  def get_valid_move(piece)
    loop do
      choice = @players[0].get_choice(2)

      return false if choice == 'back'

      coord = [choice[0].ord - 96, choice[1].to_i]

      return coord if piece.moves.include?(coord)

      puts Rainbow('Invalid move!').color(:red)
    end
  end

  def game_over?
    return 'CM' if @engine.checkmate?(@players[0], @players[1])

    return 'SM' if @engine.stalemate?(@players[0], @players[1])

    return 'DP' if @engine.dead_position?(all_pieces)

    return 'FFR' if @engine.fivefold_repetition?(all_pieces)

    return '75' if @engine.seventy_five_move_rule?

    false
  end
end
