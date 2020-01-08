require 'csv'
require_relative './loadable'
require_relative './game_teams'
require_relative './game'
require_relative './team'

class GameCollection

  include Loadable

  attr_reader :games

  def initialize(csv_file_path)
    @games = load_objects(csv_file_path, "Game")
  end

  def self.all
    @games
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

  def team_collection_offense
    team_collection = @games.reduce({}) do |team_id, game|
      team_id[game.home_team_id] = {goals_scored: 0, games_played: 0}
      team_id[game.away_team_id] = {goals_scored: 0, games_played: 0}
      team_id
    end
    @games.each do |game|
      team_collection[game.home_team_id][:games_played] += 1
      team_collection[game.away_team_id][:games_played] += 1
      team_collection[game.away_team_id][:goals_scored] += game.away_goals
      team_collection[game.home_team_id][:goals_scored] += game.home_goals
    end
    team_collection
  end

  def worst_offense
    team_worst_offense = team_collection_offense.min_by do |team, info|
      info[:goals_scored].to_f / info[:games_played]
    end[0]
    team_worst_offense_id = team_worst_offense.to_s
    Team.team_id_to_team_name(team_worst_offense_id)
  end

def best_offense
 team_worst_offense = team_collection_offense.max_by do |team, info|
   info[:goals_scored].to_f / info[:games_played]
 end[0]
 team_worst_offense_id = team_worst_offense.to_s
  Team.team_id_to_team_name(team_worst_offense_id)
end

def team_collection_defense
  team_collection = @games.reduce({}) do |team_id, game|
    team_id[game.home_team_id] = {goals_let: 0, games_played: 0}
    team_id[game.away_team_id] = {goals_let: 0, games_played: 0}
    team_id
  end
  @games.each do |game|
    team_collection[game.home_team_id][:games_played] += 1
    team_collection[game.away_team_id][:games_played] += 1
    team_collection[game.away_team_id][:goals_let] += game.home_goals
    team_collection[game.home_team_id][:goals_let] += game.away_goals
  end
  team_collection
end

def worst_defense
  team_worst_defense = team_collection_defense.max_by do |team, info|
    info[:goals_let].to_f / info[:games_played]
  end[0]
  team_worst_defense_id = team_worst_defense.to_s
    Team.team_id_to_team_name(team_worst_defense_id)
  end

def best_defense
 team_worst_defense = team_collection_defense.min_by do |team, info|
   info[:goals_let].to_f / info[:games_played]
 end[0]
 team_worst_defense_id = team_worst_defense.to_s
  Team.team_id_to_team_name(team_worst_defense_id)
end

end
