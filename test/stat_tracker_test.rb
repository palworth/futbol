require_relative '../test_helper'
require "minitest/autorun"
require 'minitest/pride'
require './lib/stat_tracker'

class StatTrackerTest < Minitest::Test
  def setup
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'
    locations = {
        games: game_path,
        teams: team_path,
        game_teams: game_teams_path
      }
    @stat_tracker = StatTracker.from_csv(locations)
  end

  def test_class_exists
    assert_instance_of StatTracker, @stat_tracker
  end

  def test_it_has_attributes
    assert_equal './data/games.csv', @stat_tracker.game_path
    assert_equal './data/teams.csv', @stat_tracker.team_path
    assert_equal './data/game_teams.csv', @stat_tracker.game_teams_path
  end

  def test_it_can_return_percentage_wins
    assert_equal 0.44, @stat_tracker.percentage_home_wins
  end

  def test_it_can_return_percentage_visitor_wins
    assert_equal 0.36, @stat_tracker.percentage_visitor_wins
  end

  def test_it_can_return_percentage_ties
    assert_equal 0.2, @stat_tracker.percentage_ties
  end

  def test_it_can_return_average_goals_by_season  
    expected = {"20122013"=>4.12, "20162017"=>4.23, "20142015"=>4.14, "20152016"=>4.16, "20132014"=>4.19, "20172018"=>4.44}
    assert_equal expected, @stat_tracker.average_goals_by_season
  end

  def test_it_can_return_the_highest_total_score
    assert_equal 11, @stat_tracker.highest_total_score
  end

  def test_it_can_return_the_lowest_total_score
    assert_equal 0, @stat_tracker.lowest_total_score
  end

  def test_it_can_return_the_biggest_blowout
    assert_equal 8, @stat_tracker.biggest_blowout
  end

  def test_it_can_return_the_count_of_games_by_season
    expected = {"20122013"=>806, "20162017"=>1317, "20142015"=>1319, "20152016"=>1321, "20132014"=>1323, "20172018"=>1355}
    assert_equal expected, @stat_tracker.count_of_games_by_season
  end

  def test_it_can_return_the_winningest_coach
    assert_equal "Dan Lacroix", @stat_tracker.winningest_coach(20122013)
  end

  def test_it_can_return_the_worst_coach
    assert_equal "Martin Raymond", @stat_tracker.worst_coach(20122013)
  end

  def test_it_can_return_the_most_accurate_team
    assert_equal "DC United", @stat_tracker.most_accurate_team(20122013)
  end

  def test_it_can_return_the_least_accurate_team
    assert_equal "New York City FC", @stat_tracker.least_accurate_team(20122013)
  end

  def test_it_can_return_the_winningest_team
    assert_equal "Reign FC", @stat_tracker.winningest_team
  end

end
