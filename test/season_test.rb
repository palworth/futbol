require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/season'

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
end
