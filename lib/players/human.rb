# frozen_string_literal: true

require 'rainbow'

require_relative './player'

# Class for the computer player
class Human < Player
  COMMANDS = %w[save back resign].freeze

  def get_choice(step)
    loop do
      print "#{print_color}, "

      print_step(step)

      choice = gets.chomp.downcase

      return choice if valid_choice?(choice)

      print_error_massage
    end
  end

  def valid_choice?(choice)
    return true if (choice.length == 2 && ('a'..'h').include?(choice[0]) && ('1'..'8').include?(choice[1])) ||
                   COMMANDS.include?(choice)

    false
  end

  def print_step(step)
    if step == 1
      print 'enter piece to move: '
    else
      print 'move piece to: '
    end
  end

  def print_error_massage
    puts Rainbow('Invalid choice.').color(:red)
    puts Rainbow('Examples: e4, a1, h8.').color(:blue)
  end

  def promote(piece)
    choice = ''
    promotable = %w[r k b q]

    loop do
      print "\nRook (R) - Knight (K) - Bishop (B) - Queen (Q)\nChoose a piece to promote to: "

      choice = gets.chomp.downcase

      break if promotable.include?(choice)

      puts Rainbow('Invalid choice!').color(:red)
    end

    handle_promotion(choice, piece)

    @pieces.delete(piece)
  end

  def handle_promotion(choice, piece)
    case choice
    when 'r'
      @pieces.unshift(Rook.new(piece.coordinates, @color))
    when 'k'
      @pieces.unshift(Knight.new(piece.coordinates, @color))
    when 'b'
      @pieces.unshift(Bishop.new(piece.coordinates, @color))
    when 'q'
      @pieces.unshift(Queen.new(piece.coordinates, @color))
    end
  end
end
