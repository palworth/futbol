require 'csv'
require_relative 'team'

class Team
  @@all = []

  def self.all
    @@all
  end

  def self.from_csv(file_path)
    csv = CSV.read("#{file_path}", headers: true, header_converters: :symbol)


    @@all = csv.map do |row|
      Team.new(row)
    end
  end

    attr_reader :team_id, :franchiseId, :teamName, :abbreviation

  def initialize(team_info)
    @team_id = team_info[:team_id]
    @franchiseId = team_info[:franchiseId]
    @teamName = team_info[:teamName]
    @abbreviation = team_info[:abbreviation]
    # @Stadium = team_info[:] #downcase
  end
  
end




## Teardown method for minitest
#this can be a self.reset method which makes an empty array again