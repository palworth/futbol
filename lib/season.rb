require_relative './game_collection'
require_relative './game_teams'

class Season

  def initialize(csv_file_path = './test/fixtures/games.csv')
    @game_collection  = GameCollection.new(csv_file_path)
  end

  def games_per_season
    @game_collection.group_by{|game| game.season}
  end

  def teams_for_season(season_id)
    @game_collection.games_per_season[season_id.to_s].map do |game|
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

end