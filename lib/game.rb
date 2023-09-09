# frozen_string_literal: true

require_relative './board'
require_relative './display'

require_relative './pieces/bishop'
require_relative './pieces/king'
require_relative './pieces/knight'
require_relative './pieces/pawn'
require_relative './pieces/queen'
require_relative './pieces/rook'

require_relative './players/player'
require_relative './players/human'
require_relative './players/computer'

class Game
  def initialize
    @players = [Human.new(:w), Human.new(:b)]
    @board = Board.new
    @turn_counter = 0
    @burner_player = Player.new(:a)
  end

  def create_players
    system('clear')

    @players.each_with_index do |player, _i|
      # player.get_name(i + 1)
      player.create_pieces
    end
  end

  def play
    loop do
      turn_order

      # break if game_over?

      @turn_counter += 1
    end

    # determine_winner
  end

  def turn_order
    @turn_counter.even? ? play_turn(@players[0], @players[1]) : play_turn(@players[1], @players[0])
  end

  def play_turn(player, enemy)
    update_player_moves(player)
    update_player_moves(enemy)

    create_board(player, enemy)

    filter_moves(player, enemy)

    piece = get_valid_pieces(player)

    create_board(player, enemy, piece)

    move = get_valid_move(player, piece)

    update_pieces(player, enemy, piece, move)
  end

  def create_board(player, enemy, piece = '')
    system('clear')

    @board.print_board(all_pieces, piece)

    puts Rainbow("Warning! #{player.print_color} is in check.").color(:red) if check?(player, enemy)
  end

  def all_pieces
    @players[0].pieces.union(@players[1].pieces)
  end

  def update_player_moves(player)
    pieces = all_pieces

    player.pieces.each do |piece|
      piece.update_player_moves(pieces)
    end
  end

  def filter_moves(player, enemy)
    player.pieces.each do |piece|
      piece.moves.filter! do |move|
        filter_moves_helper(player, enemy, piece, move)
      end
    end
  end

  def filter_moves_helper(player, enemy, piece, move)
    current_coord = piece.coordinates

    piece.move_piece(move)

    clone_player(enemy)

    update_player_moves(@burner_player)

    good_move = check?(player, @burner_player)

    piece.move_piece(current_coord)

    !good_move
  end

  def clone_player(player)
    player.pieces.each_with_index do |piece, i|
      @burner_player.pieces[i] = piece.class.new(piece.coordinates, piece.color)
    end

    update_player_moves(@burner_player)
  end

  def check?(player, enemy)
    king = player.pieces.last.coordinates

    enemy.pieces.each { |piece| return true if piece.moves.include?(king) }

    false
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
    # back
    loop do
      choice = player.get_choice(2)

      coord = [choice[0].ord - 96, choice[1].to_i]

      return coord if piece.moves.include?(coord)

      puts Rainbow('Invalid move!').color(:red)
    end
  end

  def update_pieces(player, enemy, piece_to_move, move)
    enemy.pieces.each do |piece|
      next unless move == piece.coordinates

      enemy.pieces.delete(piece)

      break
    end

    player.pieces.each do |piece|
      next unless piece_to_move == piece

      piece.move_piece(move)

      break
    end
  end
end

game = Game.new
game.create_players
game.play
