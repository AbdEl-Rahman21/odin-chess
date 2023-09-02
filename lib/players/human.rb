# frozen_string_literal: true

require_relative './player'
require 'rainbow'

class Human < Player
  def get_name(number)
    print "Player #{number} (#{@color == :w ? 'White' : 'Black'}), enter your name: "

    @name = gets.chomp
  end

  def get_choice(step)
    loop do
      print "#{@name} (#{@color == :w ? 'White' : 'Black'}), "

      print_step(step)

      choice = gets.chomp

      return choice if choice.length == 2 && ('a'..'h').include?(choice[0]) && ('1'..'8').include?(choice[1])

      print_error_massage
    end
  end

  def print_step(step)
    if step == 1
      print 'enter piece to move: '
    else
      print 'enter piece to: '
    end
  end

  def print_error_massage
    puts Rainbow('Invalid choice.').color(:red)
    puts Rainbow('Examples: e4, a1, h8.').color(:blue)
  end
end
