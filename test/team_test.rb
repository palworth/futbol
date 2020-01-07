require_relative '../test_helper'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/team'

class TeamTest < Minitest::Test
  
  def setup
    Team.from_csv('./test/fixtures/teams.csv')
    @team = Team.all[0]
  end

  def test_it_exists
    assert_instance_of Team, @team
  end

  def test_it_has_attributes
    assert_equal '1',  @team.team_id
    assert_equal '23', @team.franchiseId
    assert_equal 'Atlanta United', @team.teamName
    assert_equal 'ATL', @team.abbreviation
    assert_equal '/api/v1/teams/1', @team.link
  end

  def test_it_can_count_the_teams
    assert_equal 32, Team.count_of_teams
  end

  def test_it_can_find_a_team_by_team_id 
    assert_equal Team.all[7], Team.find_team_by_id('17')
  end

  def test_it_can_find_a_team_name_by_team_id
    assert_equal 'Houston Dynamo', Team.team_id_to_team_name('3')
  end

  def test_it_can_return_the_team_info_for_a_given_team_id
    expected = { 'team_id' => '17', 'franchise_id' => '12', 'team_name' => 'LA Galaxy', 'abbreviation' => 'LA', 'link' => '/api/v1/teams/17' }
    assert_equal expected, Team.team_info('17')
  end

end
