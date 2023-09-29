# frozen_string_literal: true

require 'rainbow'

require_relative './pieces/bishop'
require_relative './pieces/king'
require_relative './pieces/knight'
require_relative './pieces/pawn'
require_relative './pieces/queen'
require_relative './pieces/rook'

# Class for the chess board
class Board
  def initialize
    @tiles = []

    generate_tiles
  end

  def generate_tiles
    (1..8).reverse_each { |y| (1..8).each { |x| @tiles.push([x, y]) } }
  end

  def print_board(pieces, piece_to_move)
    # system('clear')

    puts "\s\s\sa\s\sb\s\sc\s\sd\s\se\s\sf\s\sg\s\sh"

    print_tiles(pieces, piece_to_move)

    puts "\s\s\sa\s\sb\s\sc\s\sd\s\se\s\sf\s\sg\s\sh"

    if piece_to_move == ''
      puts "\nCommands: save, resign.\n\n"
    else
      puts "\nCommands: back.\n\n"
    end
  end

  def print_tiles(pieces, piece_to_move)
    i = 0

    (1..8).reverse_each do |number|
      print "#{number}\s"

      8.times do
        print_tile(i, pieces, piece_to_move)

        i += 1
      end

      print "\s#{number}\n"
    end
  end

  def print_tile(index, pieces, piece_to_move)
    symbol = tile_status(index, pieces, piece_to_move)
    color = tile_color(index, pieces, piece_to_move)

    print_tile_helper(color, symbol)
  end

  def print_tile_helper(color, symbol)
    print Rainbow("\s#{symbol}").bg(color)
    print Rainbow("\s").bg(color)
  end

  def tile_color(index, pieces, piece_to_move)
    unless piece_to_move == ''
      pieces.each do |piece|
        return :crimson if piece.coordinates == @tiles[index] && piece_to_move.moves.include?(piece.coordinates)
      end
    end

    return :green if @tiles[index].sum.even?

    :snow
  end

  def tile_status(index, pieces, piece_to_move)
    pieces.each { |piece| return piece_color(piece) if piece.coordinates == @tiles[index] }

    return "\s" if piece_to_move == ''

    return Rainbow("\u25CF").color(:crimson) if piece_to_move.moves.include?(@tiles[index])

    "\s"
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/PerceivedComplexity
  # rubocop:disable Metrics/CyclomaticComplexity
  def piece_color(piece)
    if piece.instance_of?(Pawn)
      piece.color == :w ? Rainbow("\u2659").color(:black) : "\u265F"
    elsif piece.instance_of?(Rook)
      piece.color == :w ? Rainbow("\u2656").color(:black) : "\u265C"
    elsif piece.instance_of?(Knight)
      piece.color == :w ? Rainbow("\u2658").color(:black) : "\u265E"
    elsif piece.instance_of?(Bishop)
      piece.color == :w ? Rainbow("\u2657").color(:black) : "\u265D"
    elsif piece.instance_of?(Queen)
      piece.color == :w ? Rainbow("\u2655").color(:black) : "\u265B"
    elsif piece.instance_of?(King)
      piece.color == :w ? Rainbow("\u2654").color(:black) : "\u265A"
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/PerceivedComplexity
  # rubocop:enable Metrics/CyclomaticComplexity
end
