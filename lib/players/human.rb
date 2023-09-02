# frozen_string_literal: true

require_relative './player'
require 'rainbow'

class Human < Player
  def get_name(number)
    print "Player #{number} (#{@color == :w ? 'White' : 'Black'}), enter your name: "

    @name = gets.chomp
  end

  def get_choice
    loop do
      print "#{@name} (#{@color == :w ? 'White' : 'Black'}), enter piece to move: "

      choice = gets.chomp

      return choice if choice.length == 2 && ('a'..'h').include?(choice[0]) && ('1'..'8').include?(choice[1])

      print_error_massage
    end
  end

  def print_error_massage
    puts Rainbow('Invalid choice.').color(:red)
    puts Rainbow('Examples: e4, a1, h8.').color(:blue)
  end
end
