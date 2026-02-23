require 'spec_helper'

RSpec.describe StatTracker do
  before(:each) do
    game_teams_path = './data/game_teams_fixture.csv'
    game_path = './data/games_fixture.csv'
    team_path = './data/teams.csv'
    @locations = {  game_teams: game_teams_path, 
                    games: game_path, 
                    teams: team_path,
                  }
    @stats = StatTracker.from_csv(@locations)
  end

  describe '#initialize' do
    it 'exists' do
      expect(@stats).to be_a_instance_of StatTracker
    end

    it 'has attributes' do
      expect(@stats.games).to be_a_instance_of Array
      expect(@stats.game_teams).to be_a_instance_of Array
      expect(@stats.teams).to be_a_instance_of Array
    end
    
    it 'populates games from data' do
      @stats.games.each do |game|
        expect(game.away_goals.to_i).to be_a_instance_of Integer
        expect(game.away_team_id.to_i).to be_a_instance_of Integer
        expect(game.game_id.to_i).to be_a_instance_of Integer
        expect(game.home_goals.to_i).to be_a_instance_of Integer
        expect(game.home_team_id.to_i).to be_a_instance_of Integer
        expect(game.season.to_i).to be_a_instance_of Integer
      end
    end
    
    it 'populates teams from data' do
      @stats.teams.each do |team|
        expect(team.team_id.to_i).to be_a_instance_of Integer
        expect(team.team_name).to be_a_instance_of String
      end
    end
    
    it 'populates game_teams from data' do
      @stats.game_teams.each do |game_team|       
        expect(game_team.game_id.to_i).to be_a_instance_of Integer
        expect(game_team.team_id.to_i).to be_a_instance_of Integer
        expect(game_team.goals.to_i).to be_a_instance_of Integer
        expect(game_team.head_coach).to be_a_instance_of String
        expect(game_team.hoa).to eq("away").or eq("home")
        expect(game_team.result).to eq("WIN").or eq("LOSS").or eq("TIE")
        expect(game_team.shots.to_i).to be_a_instance_of Integer
        expect(game_team.tackles.to_i).to be_a_instance_of Integer
      end
    end
  end
end