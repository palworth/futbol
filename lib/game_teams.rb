require 'csv'
require_relative './loadable'

class GameTeams

  extend Loadable

  attr_reader :game_id, :team_id, :hoa, :result, :goals, :head_coach, :shots, :tackles 

  def initialize(game_team_info)
    @game_id = game_team_info[:game_id]
    @team_id = game_team_info[:team_id]
    @hoa = game_team_info[:hoa]
    @result = game_team_info[:result]
    @goals = game_team_info[:goals]
    @shots = game_team_info[:shots]
    @head_coach = game_team_info[:head_coach]
    @tackles = game_team_info[:tackles]
  end

  @@all = []

  def self.all
    @@all
  end

  def self.from_csv(file_path)
    @@all = load_objects(file_path, 'GameTeams')
  end

  def self.winningest_team
    winningest_team_id = wins_per_team.max_by { |team| team[1] }[0]
    Team.team_id_to_team_name(winningest_team_id)
  end

  def self.best_fans
    best_fan_team_id = (difference_home_and_away_wins_percentage.max_by {|team| team[1]})[0]
    Team.team_id_to_team_name(best_fan_team_id)
  end

  def self.worst_fans
    worst_fan_team_id = win_loss_perc_per_team.map do |team|
      team[1][:away_win_percentage] > team[1][:home_win_percentage] ? team[0] : nil
    end.compact
    worst_fan_team_id.map {|team_id| Team.team_id_to_team_name(team_id)}
  end

  def self.games_per_team
    # @@games_per_team ||=
    @@all.group_by {|game| game.team_id}
  end

  def self.wins_per_team
    games_per_team.reduce({}) do |result, team_result|
      result[team_result[0]] = team_result[1].count {|game| game.result == 'WIN'} / team_result[1].size.to_f
      result
    end
  end

  def self.home_away_games_per_team
    games_per_team.reduce({}) do |result, games|
      result[games[0]] = games[1].group_by {|game| game.hoa}
      result
    end
  end

  def self.win_loss_perc_per_team
    home_away_games_per_team.reduce({}) do |result, team|
      result[team[0]] = {
        away_win_percentage: ((team[1]['away'].count {|game| game.result == 'WIN'})/team[1]['away'].size.to_f).round(4),
        home_win_percentage: ((team[1]['home'].count {|game| game.result == 'WIN'})/team[1]['home'].size.to_f).round(4)
        }
      result
    end
  end

  def self.difference_home_and_away_wins_percentage
    win_loss_perc_per_team.reduce({}) do |result, team|
      result[team[0]] = ([team[1][:home_win_percentage] - team[1][:away_win_percentage] , 0.0].max).round(4)
      result
    end
  end

  def self.away_games
    away_games = {}
    games_per_team.each do |team_id, game_array|
      away_games[team_id] = game_array.find_all do |game|
        game.hoa == 'away'
      end
    end
    away_games
  end

  def self.lowest_scoring_visitor
    order = away_games.min_by do |team_id, game_array|
      total = game_array.sum do |game|
        game.goals.to_f
      end
      (total / game_array.length).round(2)
    end
    order[0]
    Team.team_id_to_team_name(order[0])
  end

  def self.highest_scoring_visitor
    order = away_games.max_by do |team_id, game_array|
      total = game_array.sum do |game|
        game.goals.to_f
      end
      (total / game_array.length).round(2)
    end
    order[0]
    Team.team_id_to_team_name(order[0])
  end

  def self.home_games
    home_games = {}
    games_per_team.each do |team_id, game_array|
      home_games[team_id] = game_array.find_all do |game|
        game.hoa == 'home'
      end
    end
    home_games
  end

  def self.highest_scoring_home_team
    order = home_games.max_by do |team_id, game_array|
      total = game_array.sum do |game|
        game.goals.to_f
      end
      (total / game_array.length).round(2)
    end
    order[0]
    Team.team_id_to_team_name(order[0])
  end

  def self.lowest_scoring_home_team
    order = home_games.min_by do |team_id, game_array|
      total = game_array.sum do |game|
        game.goals.to_f
      end
      (total / game_array.length).round(2)
    end
    order[0]
    Team.team_id_to_team_name(order[0])
  end

  def self.team_id_to_coach(team_id, season_id)
    @@all.find do |game|
      game.team_id == team_id && game.game_id[0..3] == season_id.to_s[0..3]
    end.head_coach
  end

  def self.game_id_to_coach(game_id)
    @@all.find do |game|
      game.game_id == game_id.to_s
    end.head_coach
  end

end
