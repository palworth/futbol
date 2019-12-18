require_relative '../test_helper'
require "minitest/autorun"
require 'minitest/pride'
require './lib/stat_tracker'
require './lib/game'

class GameTest < Minitest::Test
  def setup
    game_path = './test/fixtures/games.csv'
    game_info = {:game_id => "2012030221",
                 :season => "20122013",
                 :type => "Postseason",
                 :date_time => "5/16/13",
                 :away_team_id => "3",
                 :home_team_id => "6",
                 :away_goals => "2",
                 :home_goals => "3",
                 :venue => "Toyota Stadium"}
    @game = Game.new(game_info)
  end

  def test_class_exists
    assert_instance_of Game, @game
  end

  def test_game_class_has_attributes
    assert_equal "2012030221", @game.game_id
    assert_equal "20122013", @game.season
    assert_equal "Postseason", @game.type
    assert_equal "5/16/13", @game.date_time
    assert_equal 3, @game.away_team_id
    assert_equal 6, @game.home_team_id
    assert_equal 2, @game.away_goals
    assert_equal 3, @game.home_goals
    assert_equal "Toyota Stadium", @game.venue
    assert_equal "20122013", @game.season
  end

  def test_games_per_season
@game.games_per_season
  end
end
