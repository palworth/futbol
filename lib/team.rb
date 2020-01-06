require 'csv'
# require_relative 'team'
require_relative 'loadable'

class Team

  extend Loadable 

  attr_reader :team_id, :franchiseId, :teamName, :abbreviation

  def initialize(team_info)
    @team_id = team_info[:team_id]
    @franchiseId = team_info[:franchiseid]
    @teamName = team_info[:teamname]
    @abbreviation = team_info[:abbreviation]
  end

  @@all = []

  def self.all
    @@all 
  end

  #this can be a self.reset method which makes an empty array again
  ## Teardown method for minitest

  def self.from_csv(file_path)
    @@all = load_objects(file_path, 'Team')
  end

  def self.count_of_teams
    @@all.size
  end

  def self.team_id_to_team_name(team_id)
    @@all.find {|team| team.team_id == team_id}.teamName
  end

end
