require_relative '../test_helper'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/game'
require_relative '../lib/game_collection'
require_relative '../lib/team'

class GameCollectionTest < Minitest::Test
  def setup
    csv_file_path = './test/fixtures/games.csv'
    @game_collection = GameCollection.new(csv_file_path)
    @teams = Team.from_csv('./test/fixtures/teams.csv')
    @game_teams = GameTeams.from_csv('./data/game_teams.csv')
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
    expected = {'20122013'=>12, '20152016'=>9, '20132014'=>1, '20142015'=>3, '20162017'=>1}
    assert_equal expected, @game_collection.count_of_games_by_season
  end

  def test_average_goals_per_game_method
    assert_equal 4.38, @game_collection.average_goals_per_game
  end

  def test_it_finds_team_collection_defense
    expected = {6=>{:goals_let=>7, :games_played=>5},
     3=>{:goals_let=>28, :games_played=>10},
     9=>{:goals_let=>3, :games_played=>2},
     8=>{:goals_let=>9, :games_played=>3},
     16=>{:goals_let=>11, :games_played=>7},
     30=>{:goals_let=>13, :games_played=>5},
     5=>{:goals_let=>6, :games_played=>4},
     26=>{:goals_let=>12, :games_played=>5},
     28=>{:goals_let=>11, :games_played=>5},
     19=>{:goals_let=>3, :games_played=>1},
     14=>{:goals_let=>5, :games_played=>2},
     29=>{:goals_let=>1, :games_played=>1},
     13=>{:goals_let=>3, :games_played=>1},
     15=>{:goals_let=>2, :games_played=>1}}
    assert_equal expected, @game_collection.team_collection_defense
  end

  def test_it_finds_team_collection_offense
    expected = {6=>{:goals_scored=>14, :games_played=>5},
     3=>{:goals_scored=>17, :games_played=>10},
     9=>{:goals_scored=>7, :games_played=>2},
     8=>{:goals_scored=>4, :games_played=>3},
     16=>{:goals_scored=>16, :games_played=>7},
     30=>{:goals_scored=>7, :games_played=>5},
     5=>{:goals_scored=>12, :games_played=>4},
     26=>{:goals_scored=>11, :games_played=>5},
     28=>{:goals_scored=>12, :games_played=>5},
     19=>{:goals_scored=>2, :games_played=>1},
     14=>{:goals_scored=>4, :games_played=>2},
     29=>{:goals_scored=>3, :games_played=>1},
     13=>{:goals_scored=>2, :games_played=>1},
     15=>{:goals_scored=>3, :games_played=>1}}
    assert_equal expected, @game_collection.team_collection_offense
  end

  def test_it_finds_best_offense
    assert_equal 'New York City FC', @game_collection.best_offense
  end

  def test_it_finds_worst_offense
    assert_equal 'New York Red Bulls', @game_collection.worst_offense
  end

  def test_worst_defense
    assert_equal 'New York Red Bulls', @game_collection.worst_defense
  end

  def test_best_defense
    assert_equal 'Orlando Pride', @game_collection.best_defense
  end

end
