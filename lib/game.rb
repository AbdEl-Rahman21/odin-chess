# frozen_string_literal: true

require 'rainbow'

require_relative './engine'

require_relative './pieces/king'
require_relative './pieces/pawn'

require_relative './players/human'
require_relative './players/computer'

# Class for chess game loop
class Game
  attr_reader :players
  attr_accessor :state

  def initialize(players)
    @players = players
    @engine = Engine.new
    @turn_counter = 0
    @state = nil
  end

  def all_pieces
    @players[0].pieces.union(@players[1].pieces)
  end

  def create_players
    @players.each(&:create_pieces)
  end

  def update_all_moves
    @players.each { |player| @engine.update_player_moves(player, all_pieces) }

    update_special_moves
  end

  def update_special_moves
    @players.each do |player|
      player.pieces.each do |piece|
        if piece.instance_of?(Pawn)

          piece.in_passing(all_pieces)

        elsif piece.instance_of?(King)

          piece.castling(all_pieces)

        end
      end
    end
  end

  def play
    while @state.nil?
      update_all_moves

      turn_order

      prepare

      break unless @state.nil?

      play_turn

      @turn_counter += 1 if @state.nil?
    end

    @engine.create_board(@players[0], @players[1], all_pieces, final: true)
  end

  def turn_order
    # rubocop:disable Layout/LineLength
    @players.reverse! if (@turn_counter.even? && @players[0].color == :b) || (@turn_counter.odd? && @players[0].color == :w)
    # rubocop:enable Layout/LineLength
  end

  def prepare
    @engine.filter_moves(@players[0], Marshal.dump(@players[1]), all_pieces)

    @state = game_over? if @state.nil?
  end

  def game_over?
    return 'CM' if @engine.checkmate?(@players[0], @players[1])

    return 'SM' if @engine.stalemate?(@players[0], @players[1])

    return 'DP' if @engine.dead_position?(all_pieces)

    return 'FFR' if @engine.fivefold_repetition?(all_pieces)

    return '75' if @engine.seventy_five_move_rule?

    nil
  end

  def play_turn(move = '', piece = '')
    while move.instance_of?(String)
      @engine.create_board(@players[0], @players[1], all_pieces)

      piece = get_valid_piece

      return if command?(piece)

      @engine.create_board(@players[0], @players[1], all_pieces, piece)

      sleep(1.5) if @players[0].instance_of?(Computer)

      move = get_valid_move(piece)
    end

    update_engine_info(piece, move)
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Naming/AccessorMethodName
  def get_valid_piece
    puts "\nCommands: save, resign.\n\n" if @players[0].instance_of?(Human)

    loop do
      choice = @players[0].get_choice(1)

      return choice if %w[save resign].include?(choice)

      coord = [choice[0].ord - 96, choice[1].to_i]

      @players[0].pieces.each { |piece| return piece if piece.coordinates == coord && !piece.moves.empty? }

      puts Rainbow("Invalid choice: Tile is empty or piece can't move!").color(:red)
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Naming/AccessorMethodName

  def command?(choice)
    if choice.instance_of?(String)
      @state = choice

      return true
    end

    false
  end

  def get_valid_move(piece)
    puts "\nCommands: back.\n\n" if @players[0].instance_of?(Human)

    loop do
      choice = @players[0].get_choice(2)

      return choice if choice == 'back'

      coord = [choice[0].ord - 96, choice[1].to_i]

      return coord if piece.moves.include?(coord)

      puts Rainbow('Invalid move!').color(:red)
    end
  end

  def update_engine_info(piece, move)
    @engine.update_pieces(@players[0], @players[1], piece, move)

    @engine.update_counters(all_pieces)
  end
end
