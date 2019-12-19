require_relative './game_collection'
require_relative './game'

class StatTracker
  attr_reader :game_path, :team_path, :game_teams_path

  def self.from_csv(locations)
    game_path = locations[:games]
    team_path = locations[:teams]
    game_teams_path = locations[:game_teams]

    StatTracker.new(game_path, team_path, game_teams_path)
  end

  def initialize(game_path, team_path, game_teams_path)
    @game_path = game_path
    @team_path = team_path
    @game_teams_path = game_teams_path
    @game_collection = game_collection
  end

  def game_collection
     GameCollection.new(@game_path)
  end

  def percentage_home_wins
  end

  def percentage_visitor_wins
  end

  def percentage_ties
  end

  def average_goals_by_season
  end

  def highest_total_score
  end

  def lowest_total_score

  end

  def biggest_blowout


  end

  def games_per_season

  end


end
