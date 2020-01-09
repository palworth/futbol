require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/season'
require 'mocha/minitest'

class SeasonTest < Minitest::Test

  def setup
    @season = Season.new
    @game_teams = GameTeams.from_csv('./data/game_teams.csv')
    @teams = Team.from_csv('./test/fixtures/teams.csv')
  end

  def test_it_exists
    assert_instance_of Season, @season
  end

  def test_it_has_attributes
    # assert_equal '20122013', @season.game_collection
  end

  def test_it_can_find_the_winningest_coach_for_a_given_season
    assert_equal 'Claude Julien', @season.winningest_coach(20122013)
  end

  def test_it_can_find_the_worst_coach_for_a_given_season
    assert_equal 'John Tortorella', @season.worst_coach(20122013)
  end

  def test_it_can_find_the_number_of_shots_and_goals_per_team
    expected = {'29' => [5, 3], '14' => [16, 4], '13' =>[5, 2], '3' => [7, 2], '15' => [11, 3]}
    assert_equal true, expected == @season.shots_and_goals_per_team(20142015)
  end

  def test_it_can_determine_the_ratio_of_shots_to_goals_per_team
    expected = {'29' => 1.667, '14' => 4.0, '13' => 2.5, '3' => 3.5, '15' => 3.667}
    assert_equal true, expected == @season.ratio_shots_to_goals_per_team(20142015)
  end

  def test_it_can_find_the_most_accurate_team
    assert_equal 'Orlando Pride', @season.most_accurate_team(20142015)
  end

  def test_it_can_find_the_least_accurate_team
    assert_equal 'DC United', @season.least_accurate_team(20142015)
  end

  def test_most_tackles_by_team_by_season
    assert_equal "FC Dallas", @season.most_tackles("20122013")
  end

  def test_fewest_tackles_by_team_by_season
    assert_equal "New York Red Bulls", @season.fewest_tackles("20122013")
  end

  def test_determine_total_tackles_per_team_by_season
    expected = {"3"=>154, "6"=>170, "8"=>68, "9"=>77, "30"=>165, "16"=>146}
    assert_equal expected, @season.total_tackles_per_team("20122013")
  end

  def test_it_returns_games_per_season_type
    expected_1 = @season.game_collection.games[21..22]
    expected_2 = @season.game_collection.games[0..20] + @season.game_collection.games[23..25]
    assert_equal expected_1, @season.games_per_season_type(@season.game_collection.games, "Regular Season")
    assert_equal expected_2, @season.games_per_season_type(@season.game_collection.games, "Postseason")
  end

  def test_it_returns_game_per_team_id
    team_3 = @season.game_collection.games.values_at(0,1,2,3,11,12,13,14,24,25)
    team_5 = @season.game_collection.games.values_at(11,12,13,14)
    team_6 = @season.game_collection.games.values_at(0,1,2,3,23)
    team_8 = @season.game_collection.games.values_at(4, 5, 24)
    team_9 = @season.game_collection.games.values_at(4,5)
    team_13 = @season.game_collection.games.values_at(22)
    team_14 = @season.game_collection.games.values_at(21,22)
    team_15 = @season.game_collection.games.values_at(25)
    team_16 = @season.game_collection.games.values_at(6,7,8,9,10,20,23)
    team_19 = @season.game_collection.games.values_at(20)
    team_26 = @season.game_collection.games.values_at(15,16,17,18,19)
    team_28 = @season.game_collection.games.values_at(15,16,17,18,19)
    team_29 = @season.game_collection.games.values_at(-5)
    team_30 = @season.game_collection.games.values_at(6,7,8,9,10)
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
    assert_equal expected, @season.games_per_team_id(@season.game_collection.games)
  end

  def test_win_log_per_team
    team_3 = @season.game_collection.games.values_at(0,1,2,3,11,12,13,14,24,25)
    team_5 = @season.game_collection.games.values_at(11,12,13,14)
    team_6 = @season.game_collection.games.values_at(0,1,2,3,23)
    team_8 = @season.game_collection.games.values_at(4, 5, 24)
    team_9 = @season.game_collection.games.values_at(4,5)
    team_13 = @season.game_collection.games.values_at(22)
    team_14 = @season.game_collection.games.values_at(21,22)
    team_15 = @season.game_collection.games.values_at(25)
    team_16 = @season.game_collection.games.values_at(6,7,8,9,10,20,23)
    team_19 = @season.game_collection.games.values_at(20)
    team_26 = @season.game_collection.games.values_at(15,16,17,18,19)
    team_28 = @season.game_collection.games.values_at(15,16,17,18,19)
    team_29 = @season.game_collection.games.values_at(-5)
    team_30 = @season.game_collection.games.values_at(6,7,8,9,10)
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
    expected = { '3' => [false, false, false, false, false, false, false, false, true, false],
      '5' => [false, true, true, true],
      '6' => [true, true, true, true, true],
      '8' => [false, false, false],
      '9' => [true, true],
      '13' => [false],
      '14' => [false, true],
      '15' => [true],
      '16' => [true, true, false, true, true, true, false],
      '19' => [false],
      '26' => [true, false, true, false, false],
      '28' => [false, true, false, true, true],
      '29' => [true],
      '30' => [false, false, true, false, false]}
    assert_equal expected, @season.win_log_per_team(games_log_per_team)
  end

  def test_it_returns_win_percentage_per_team
    team_3 = @season.game_collection.games.values_at(0,1,2,3,11,12,13,14,24,25)
    team_5 = @season.game_collection.games.values_at(11,12,13,14)
    team_6 = @season.game_collection.games.values_at(0,1,2,3,23)
    team_8 = @season.game_collection.games.values_at(4, 5, 24)
    team_9 = @season.game_collection.games.values_at(4,5)
    team_13 = @season.game_collection.games.values_at(22)
    team_14 = @season.game_collection.games.values_at(21,22)
    team_15 = @season.game_collection.games.values_at(25)
    team_16 = @season.game_collection.games.values_at(6,7,8,9,10,20,23)
    team_19 = @season.game_collection.games.values_at(20)
    team_26 = @season.game_collection.games.values_at(15,16,17,18,19)
    team_28 = @season.game_collection.games.values_at(15,16,17,18,19)
    team_29 = @season.game_collection.games.values_at(-5)
    team_30 = @season.game_collection.games.values_at(6,7,8,9,10)
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

    @season.expects(:win_log_per_team).with(games_log_per_team).returns(
    { '3' => [false, false, false, false, false, false, false, false, true, false],
      '5' => [false, true, true, true],
      '6' => [true, true, true, true, true],
      '8' => [false, false, false],
      '9' => [true, true],
      '13' => [false],
      '14' => [false, true],
      '15' => [true],
      '16' => [true, true, false, true, true, true, false],
      '19' => [false],
      '26' => [true, false, true, false, false],
      '28' => [false, true, false, true, true],
      '29' => [true],
      '30' => [false, false, true, false, false]})
    win_logs = @season.win_log_per_team(games_log_per_team)
    assert_equal expected, @season.win_percentage_per_team(win_logs)
  end

  def test_biggest_bust
    @season.expects(:biggest_bust).with(20142015).returns("DC United")
    assert_equal "DC United", @season.biggest_bust(20142015)
  end



end
