require_relative '../test_helper'
require "minitest/autorun"
require 'minitest/pride'
require_relative '../lib/game'
require_relative '../lib/game_collection'
require_relative '../lib/team'

class GameCollectionTest < Minitest::Test
  def setup
    csv_file_path = './test/fixtures/games.csv'
    @game_collection = GameCollection.new(csv_file_path)
    @teams = Team.from_csv("./test/fixtures/teams.csv")
    @game_teams = GameTeams.from_csv("./data/game_teams.csv")
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

  def test_it_finds_best_offense
    assert_equal "New York City FC", @game_collection.best_offense
  end

  def test_it_finds_worst_offense
    assert_equal "New York Red Bulls", @game_collection.worst_offense
  end

  def test_worst_defense
    assert_equal "New York Red Bulls", @game_collection.worst_defense
  end

  def test_best_defense
    assert_equal "Orlando Pride", @game_collection.best_defense
  end

  def test_it_can_find_the_most_accurate_team
    assert_equal "Orlando Pride", @game_collection.most_accurate_team(20142015)
  end

   def test_it_can_find_the_least_accurate_team
    assert_equal "DC United", @game_collection.least_accurate_team(20142015)
  end

  def test_it_returns_games_per_season_type
    # require "pry"; binding.pry
    expected_1 = @game_collection.games[21..22]
    expected_2 = @game_collection.games[0..20] + @game_collection.games[23..25]
    assert_equal expected_1, @game_collection.games_per_season_type("Regular Season")
    assert_equal expected_2, @game_collection.games_per_season_type("Postseason")
  end

  def test_it_returns_game_per_team_id
    team_3 = @game_collection.games.values_at(0,1,2,3,11,12,13,14,24,25)
    team_5 = @game_collection.games.values_at(11,12,13,14)
    team_6 = @game_collection.games.values_at(0,1,2,3,23)
    team_8 = @game_collection.games.values_at(4, 5, 24)
    team_9 = @game_collection.games.values_at(4,5)
    team_13 = @game_collection.games.values_at(22)
    team_14 = @game_collection.games.values_at(21,22)
    team_15 = @game_collection.games.values_at(25)
    team_16 = @game_collection.games.values_at(6,7,8,9,10,20,23)
    team_19 = @game_collection.games.values_at(20)
    team_26 = @game_collection.games.values_at(15,16,17,18,19)
    team_28 = @game_collection.games.values_at(15,16,17,18,19)
    team_29 = @game_collection.games.values_at(-5)
    team_30 = @game_collection.games.values_at(6,7,8,9,10)
    expected = {
      "3" => team_3,
      "5" => team_5,
      "6" => team_6,
      "8" => team_8,
      "9" => team_9,
      "13" => team_13,
      "14" => team_14,
      "15" => team_15,
      "16" => team_16,
      "19" => team_19,
      "26" => team_26,
      "28" => team_28,
      "29" => team_29,
      "30" => team_30
    }
    assert_equal  expected, @game_collection.games_per_team_id(@game_collection.games)
  end

  def test_it_returns_win_percentage_per_team
    team_3 = @game_collection.games.values_at(0,1,2,3,11,12,13,14,24,25)
    team_5 = @game_collection.games.values_at(11,12,13,14)
    team_6 = @game_collection.games.values_at(0,1,2,3,23)
    team_8 = @game_collection.games.values_at(4, 5, 24)
    team_9 = @game_collection.games.values_at(4,5)
    team_13 = @game_collection.games.values_at(22)
    team_14 = @game_collection.games.values_at(21,22)
    team_15 = @game_collection.games.values_at(25)
    team_16 = @game_collection.games.values_at(6,7,8,9,10,20,23)
    team_19 = @game_collection.games.values_at(20)
    team_26 = @game_collection.games.values_at(15,16,17,18,19)
    team_28 = @game_collection.games.values_at(15,16,17,18,19)
    team_29 = @game_collection.games.values_at(-5)
    team_30 = @game_collection.games.values_at(6,7,8,9,10)
    games_log_per_team = {
      "3" => team_3,
      "5" => team_5,
      "6" => team_6,
      "8" => team_8,
      "9" => team_9,
      "13" => team_13,
      "14" => team_14,
      "15" => team_15,
      "16" => team_16,
      "19" => team_19,
      "26" => team_26,
      "28" => team_28,
      "29" => team_29,
      "30" => team_30
    }

    expected = {
      "3" => 0.1, "5" => 0.75, "6" => 1.0, "8" => 0.0, "9" => 1.0, "13" => 0.0,
      "14" => 0.5, "15" => 1.0, "16" => 0.714, "19" => 0.0, "26" => 0.4, "28" => 0.6, "29" => 1.0, "30" => 0.2
    }
    win_logs = @game_collection.win_log_per_team(games_log_per_team)
    assert_equal expected, @game_collection.win_percentage_per_team(win_logs)

  end

  def test_biggest_bust
    assert_equal "DC United", @game_collection.biggest_bust
  end

end
