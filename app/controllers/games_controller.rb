require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def valid_attempt?(attempt)
    check_dictionary = URI.open("https://wagon-dictionary.herokuapp.com/#{attempt.downcase}")
    valid_word = JSON.parse(check_dictionary.read)
    return valid_word["found"]
  end

  def score
    @message = "NOPE"
    @attempt_grid = params[:attempt_grid]
    @attempt_word = params[:user_word].upcase
    if !(@attempt_word.chars.all? { |letter| @attempt_word.count(letter) <= @attempt_grid.count(letter) })
      @message = "Your attempt does not seem to be contained in the grid: #{@attempt_grid}"
    elsif !valid_attempt?(@attempt_word)
      @message = "Your attempt does not seem to be an English word."
    else
      @message = "Congratulations! #{@attempt_word} is a valid attempt."
    end
  end
end
