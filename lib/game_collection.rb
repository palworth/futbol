require_relative './game'
require 'csv'
require_relative './loadable'

class GameCollection

  include Loadable

  attr_reader :games

  def initialize(csv_file_path)
    @games = load_objects(csv_file_path, "Game")
  end

  def highest_total_score
    highest_scoring_game = @games.max_by do |game|
      game.home_goals + game.away_goals
    end
    highest_scoring_game.home_goals + highest_scoring_game.away_goals
  end

  def lowest_total_score
    lowest_scoring_game = @games.min_by do |game|
      game.home_goals + game.away_goals
    end
    lowest_scoring_game.home_goals + lowest_scoring_game.away_goals
  end

  def biggest_blowout
    blowout = @games.max_by do |game|
      (game.home_goals - game.away_goals).abs
    end
    (blowout.home_goals - blowout.away_goals).abs
  end

  def percentage_home_wins
    (@games.count {|game| game.home_goals > game.away_goals} / @games.size.to_f ).round(2)
  end

  def percentage_visitor_wins
    (@games.count {|game| game.away_goals > game.home_goals} / @games.size.to_f ).round(2)
  end

  def percentage_ties
     (@games.count {|game| game.away_goals == game.home_goals} / @games.size.to_f ).round(2)
  end

  def count_of_games_by_season
    games_per_season.reduce({}) do |output, game|
      output[game[0]] = game[1].length
      output
    end
  end

  def average_goals_per_game
    game_goals_total = @games.sum {|game| game.away_goals + game.home_goals}
    (game_goals_total / @games.length.to_f).round(2)
  end

  def average_goals_by_season
    games_per_season.reduce({}) do |result, season|
      sum_goals = season[1].sum do |game|
        game.away_goals + game.home_goals
      end
      result[season[0]] = (sum_goals/season[1].size.to_f).round(2)
      result
    end
  end

  def games_per_season
    @games_per_season ||= @games.group_by{|game| game.season}
  end

end 
