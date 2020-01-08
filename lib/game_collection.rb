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

  def teams_for_season(season_id)
    games_per_season[season_id.to_s].map do |game|
      GameTeams.all.find_all {|game_team| game_team.game_id == game.game_id}
    end.flatten
  end

  def games_per_coach_for_season(season_id)
    teams_for_season(season_id).group_by {|game| game.head_coach}
  end

  def results_per_coach(season_id)
    games_per_coach_for_season(season_id).reduce({}) do |result, coach_data|
      win_count = coach_data[1].count {|game| game.result == 'WIN'}
      loss_count = coach_data[1].count {|game| game.result == 'LOSS'}
      tie_count = coach_data[1].count {|game| game.result == 'TIE'}
      result[coach_data[0]] = [win_count, loss_count, tie_count]
      result
    end
  end

  def perc_per_coach(season_id)
    results_per_coach(season_id).reduce({}) do |result, coach_count|
      result[coach_count[0]] = [0.0, 0.0] if result[coach_count[0]].nil?
      result[coach_count[0]][0] = (coach_count[1][0] / (coach_count[1][0] + coach_count[1][1] + coach_count[1][2]).to_f).round(4)
      result[coach_count[0]][1] = (coach_count[1][1] / (coach_count[1][0] + coach_count[1][1] + coach_count[1][2]).to_f).round(4)
      result
    end
  end

  def winningest_coach(season_id)
    best_coach = perc_per_coach(season_id).max_by {|coach_perc| coach_perc[1][0]}
    best_coach[0]
  end

  def worst_coach(season_id)
    worst_coach = perc_per_coach(season_id).min_by {|coach_perc| coach_perc[1][0]}
    worst_coach[0]
  end

  def shots_and_goals_per_team(season_id)
    teams = teams_for_season(season_id).group_by {|team| team.team_id}
    teams.reduce({}) do |result, team|
      count_shots = team[1].sum {|game_team| game_team.shots.to_i}
      count_goals = team[1].sum {|game_team| game_team.goals.to_i}
      result[team[0]] = [count_shots, count_goals]
      result
    end
  end

  def ratio_shots_to_goals_per_team(season_id)
    shots_and_goals_per_team(season_id).reduce({}) do |result, team|
      result[team[0]] = (team[1][0] / team[1][1].to_f).round(3)
      result
    end
  end

  def most_accurate_team(season_id)
    most_accurate_team = ratio_shots_to_goals_per_team(season_id).min_by {|team| team[1]}
    Team.team_id_to_team_name(most_accurate_team[0])
  end

  def least_accurate_team(season_id)
    least_accurate_team = ratio_shots_to_goals_per_team(season_id).max_by {|team| team[1]}
    Team.team_id_to_team_name(least_accurate_team[0])
  end

  def team_hash
    team_hash = @games.reduce({}) do |team_id, game|
      team_id[game.home_team_id] = {goals_scored: 0, games_played: 0}
      team_id[game.away_team_id] = {goals_scored: 0, games_played: 0}
      team_id
    end
    teams = @games.each do |game|
      team_hash[game.home_team_id][:games_played] += 1
      team_hash[game.away_team_id][:games_played] += 1
      team_hash[game.away_team_id][:goals_scored] += game.away_goals
      team_hash[game.home_team_id][:goals_scored] += game.home_goals
    end
    teams
  end

  def worst_offense
    team_worst_offense = team_hash.min_by do |team, info|
      info[:goals_scored].to_f / info[:games_played]
    end[0]
    team_worst_offense_id = team_worst_offense.to_s
    Team.team_id_to_team_name(team_worst_offense_id)
  end

  def best_offense
   team_worst_offense = team_hash.max_by do |team, info|
     info[:goals_scored].to_f / info[:games_played]
   end[0]
   team_worst_offense_id = team_worst_offense.to_s
    Team.team_id_to_team_name(team_worst_offense_id)
  end

  def worst_defense
    team_worst_defense = team_hash.max_by do |team, info|
      info[:goals_let].to_f / info[:games_played]
    end[0]
    team_worst_defense_id = team_worst_defense.to_s
      Team.team_id_to_team_name(team_worst_defense_id)
    end

  def best_defense
   team_worst_defense = team_hash.min_by do |team, info|
     info[:goals_let].to_f / info[:games_played]
   end[0]
   team_worst_defense_id = team_worst_defense.to_s
    Team.team_id_to_team_name(team_worst_defense_id)
  end

  def total_tackles_per_team(season_id)
    game_per_team_per_season = teams_for_season(season_id).group_by {|game_team| game_team.team_id}
    tackles_per_team = game_per_team_per_season.reduce({}) do |result, team_games|
      result[team_games[0]] = team_games[1].sum do |game|
      game.tackles.to_i
    end
    result
    end
  end

  def most_tackles(season_id)
    most_tackles_team_id = (total_tackles_per_team(season_id).max_by {|team| team[1]})[0]
    Team.team_id_to_team_name(most_tackles_team_id)
  end

  def fewest_tackles(season_id)
    fewest_tackles_team_id = (total_tackles_per_team(season_id).min_by {|team| team[1]})[0]
    Team.team_id_to_team_name(fewest_tackles_team_id)
  end
end
