require 'csv'
require_relative 'loadable'

class Team

  extend Loadable

  attr_reader :team_id, :franchiseId, :teamName, :abbreviation, :link

  def initialize(team_info)
    @team_id = team_info[:team_id]
    @franchiseId = team_info[:franchiseid]
    @teamName = team_info[:teamname]
    @abbreviation = team_info[:abbreviation]
    @link = team_info[:link]
  end

  @@all = []

  def self.all
    @@all
  end

  def self.from_csv(file_path)
    @@all = load_objects(file_path, 'Team')
  end

  def self.count_of_teams
    @@all.size
  end

  def self.find_team_by_id(team_id)
    @@all.find { |team| team.team_id == team_id }
  end

  def self.team_id_to_team_name(team_id)
    find_team_by_id(team_id).teamName
  end

  def self.team_info(team_id)
    team = find_team_by_id(team_id)
    { 'team_id' => team.team_id,
      'franchise_id' => team.franchiseId,
      'team_name' => team.teamName,
      'abbreviation' => team.abbreviation,
      'link' => team.link }
  end

end
