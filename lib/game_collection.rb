require './lib/game'
require 'csv'

class GameCollection
attr_reader :games

  def initialize(csv_file_path)
    @games = create_games(csv_file_path)
  end

  def create_games(csv_file_path)
    csv = CSV.read("#{csv_file_path}", headers: true, header_converters: :symbol)
    csv.map do |row|
      Game.new(row)
    end
  end

  def games_per_season
    games_per_season_hash = @games.group_by {|game| game.season}
    games_per_season_hash.reduce({}) do |new_hash, game|
      require "pry"; binding.pry
      new_hash[game[0]] = game[1].length
      new_hash
    end
  end
# count_of_games_by_season	A hash with season names (e.g. 20122013) as keys and counts of games as values	Hash
# average_goals_per_game	Average number of goals scored in a game across all seasons including both home and away goals (rounded to the nearest 100th)	Float
end
