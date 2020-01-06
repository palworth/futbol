require_relative '../test_helper'
require "minitest/autorun"
require 'minitest/pride'
require_relative '../lib/game'
require_relative '../lib/game_collection'

class GameCollectionTest < Minitest::Test
  def setup
    
    csv_file_path = './test/fixtures/games.csv'
    @game_collection ||= GameCollection.new(csv_file_path)
    @teams = Team.from_csv("./test/fixtures/teams.csv")
    # @game_teams ||= GameTeams.from_csv("./data/game_teams.csv")
  end

  def test_it_exists
    assert_instance_of GameCollection, @game_collection
  end

  def test_it_can_create_games
    assert_instance_of Array, @game_collection.games
    @game_collection.games.each do |game|
      assert_instance_of Game, game
    end
  end

  def test_it_can_find_highest_total_score
    assert_equal 7, @game_collection.highest_total_score
  end

  def test_it_can_find_lowest_total_score
    assert_equal 2, @game_collection.lowest_total_score
  end

  def test_it_can_find_biggest_blowout
    assert_equal 3, @game_collection.biggest_blowout
  end

  def test_it_can_return_percentage_home_wins
    assert_equal 0.54, @game_collection.percentage_home_wins
  end

  def test_it_can_return_percentage_visitor_wins
    assert_equal 0.42, @game_collection.percentage_visitor_wins
  end

  def test_it_can_return_percentage_tie_wins
    assert_equal 0.04, @game_collection.percentage_ties
  end

  def test_count_of_games_by_season_method
    expected = {"20122013"=>12, "20152016"=>9, "20132014"=>1, "20142015"=>3, "20162017"=>1}
    assert_equal expected, @game_collection.count_of_games_by_season
  end

  def test_average_goals_per_game_method
    assert_equal 4.38, @game_collection.average_goals_per_game
  end

  def test_it_can_find_the_winningest_coach_for_a_given_season
    assert_equal "Claude Julien", @game_collection.winningest_coach(20122013)
  end

  def test_it_can_find_the_worst_coach_for_a_given_season
    assert_equal "John Tortorella", @game_collection.worst_coach(20122013)
  end

  def test_it_can_find_the_number_of_shots_and_goals_per_team
    expected = {"29" => [5, 3], "14" => [16, 4], "13" =>[5, 2], "3" => [7, 2], "15" => [11, 3]}
    assert_equal true, expected == @game_collection.shots_and_goals_per_team(20142015)
  end

  def test_it_can_determine_the_ratio_of_shots_to_goals_per_team
    expected = {"29" => 1.667, "14" => 4.0, "13" => 2.5, "3" => 3.5, "15" => 3.667}
    assert_equal true, expected == @game_collection.ratio_shots_to_goals_per_team(20142015)
  end

  def test_it_can_find_the_most_accurate_team
    assert_equal "Orlando Pride", @game_collection.most_accurate_team(20142015)
  end

   def test_it_can_find_the_least_accurate_team
    assert_equal "DC United", @game_collection.least_accurate_team(20142015)
  end

end

