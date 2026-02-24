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

  describe 'Game Statistics' do
    describe '#highest_total_score' do
      it 'returns highest sum of winning and losing teams scores' do
        expect(@stats.highest_total_score).to be_a_instance_of Integer
      end
    end
    
    describe '#lowest_total_score' do
      it 'returns Lowest sum of the winning and losing teams scores' do
        expect(@stats.lowest_total_score).to be_a_instance_of Integer
        expect(@stats.lowest_total_score).to eq 0
        
      end
    end
  
    describe '#percentage_home_wins' do
      it 'returns Percentage of games that a home team has won (rounded to the nearest 100th)' do
        expect(@stats.percentage_home_wins).to be_a_instance_of Float
        expect(@stats.percentage_home_wins).to eq 0.48

        end
    end

    describe '#percentage_visitor_wins' do
      it 'returns Percentage of games that a visitor has won (rounded to the nearest 100th)' do
        expect(@stats.percentage_visitor_wins).to be_a_instance_of Float
        expect(@stats.percentage_visitor_wins).to eq 0.39
      end
    end

    describe '#percentage_ties' do
      it 'returns Percentage of games that has resulted in a tie (rounded to the nearest 100th)' do
        expect(@stats.percentage_ties).to be_a_instance_of Float
        expect(@stats.percentage_ties).to eq 0.13
      end

      it 'totals 100' do
        expect(@stats.percentage_ties + 
          @stats.percentage_visitor_wins + 
          @stats.percentage_home_wins).to eq 1.0
      end
    end

    describe '#count_of_games_by_season' do
      it 'returns A hash with season names (e.g. 20122013) as keys and counts of games as values' do
        expect(@stats.count_of_games_by_season).to be_a_instance_of Hash
        @stats.count_of_games_by_season.each do |season, count|
          expect(season.to_i).to be_a_instance_of Integer
          expect(season).to eq("20122013").or eq("20152016").or eq("20162017").or eq("20172018")
          expect(count).to be_a_instance_of Integer
          expect(count).to be < 50
        end
      end
    end

    describe '#average_goals_per_game' do
      it 'returns Average number of goals scored in a game across all seasons including both home and away goals (rounded to the nearest 100th)' do
        expect(@stats.average_goals_per_game).to be_a_instance_of Float
      end
    end
    
    describe '#average_goals_by_season' do
      it 'returns Average number of goals scored in a game organized in a hash with season names
        as keys and a float representing the average number of goals in a game for that season 
        as values (rounded to the nearest 100th)' do  
        expect(@stats.average_goals_by_season).to be_a_instance_of Hash
        @stats.average_goals_by_season.each do |season, avg|
          expect(season).to eq("20122013").or eq("20152016").or eq("20162017").or eq("20172018")
          expect(avg).to be_a_instance_of Float
        end
      end
    end
  end

  describe 'League Statistics' do
    describe '#count_of_teams' do
    	it 'returns Total number of teams in the data as Integer' do
        expect(@stats.count_of_teams).to be_a_instance_of Integer 
        expect(@stats.count_of_teams).to eq(@stats.teams.count)
    	end
    end

    describe '#best_offense' do
    	it 'returns Name of the team with the highest average number of goals scored per game across all seasons as a	String' do
        expect(@stats.best_offense).to be_a_instance_of String
        expect(@stats.best_offense).to eq("Los Angeles FC")
    	end
    end

    describe '#worst_offense' do
    	it 'returns Name of the team with the lowest average number of goals scored per game across all seasons as a String' do
        expect(@stats.worst_offense).to be_a_instance_of String
        expect(@stats.worst_offense).to eq("Sporting Kansas City")
    	end
    end

    describe '#highest_scoring_visitor' do
    	it 'returns Name of the team with the highest average score per game across all seasons when they are away as a String' do
        expect(@stats.highest_scoring_visitor).to be_a_instance_of String
        expect(@stats.highest_scoring_visitor).to eq("New York Red Bulls")
    	end
    end

    describe '#highest_scoring_home_team' do
    	it 'returns Name of the team with the highest average score per game across all seasons when they are home as a String' do
        expect(@stats.highest_scoring_home_team).to be_a_instance_of String
        expect(@stats.highest_scoring_home_team).to eq("Los Angeles FC")
    	end
    end

    describe '#lowest_scoring_visitor' do
    	it 'returns Name of the team with the lowest average score per game across all seasons when they are a visitor as a String' do
        expect(@stats.lowest_scoring_visitor).to be_a_instance_of String
        expect(@stats.lowest_scoring_visitor).to eq("Sporting Kansas City")
    	end
    end

    describe '#lowest_scoring_home_team' do
    	it 'returns Name of the team with the lowest average score per game across all seasons when they are at home as a String' do
        expect(@stats.lowest_scoring_home_team).to be_a_instance_of String
        expect(@stats.lowest_scoring_home_team).to eq("Sporting Kansas City")
    	end
    end
  end

  describe 'Season Statistics' do
    describe '#winningest_coach' do
    	it 'returns Name of the Coach with the best win percentage for the season as a String' do
        expect(@stats.winningest_coach).to be_a_instance_of String
    	end
    end

    describe '#worst_coach' do
    	it 'returns Name of the Coach with the worst win percentage for the season as a	String' do
        expect(@stats.worst_coach).to be_a_instance_of String
    	end
    end

    describe '#most_accurate_team' do
    	it 'returns Name of the Team with the best ratio of shots to goals for the season as a String' do
        expect(@stats.most_accurate_team).to be_a_instance_of String
    	end
    end

    describe '#least_accurate_team' do
    	it 'returns Name of the Team with the worst ratio of shots to goals for the season as a	String' do
        expect(@stats.least_accurate_team).to be_a_instance_of String
    	end

    end 

    describe '#most_tackles' do
    	it 'returns Name of the Team with the most tackles in the season as a	String' do
        expect(@stats.most_tackles).to be_a_instance_of String
    	end
    end

    describe '#fewest_tackles' do
    	it 'returns Name of the Team with the fewest tackles in the season as a	String' do
        expect(@stats.fewest_tackles).to be_a_instance_of String
    	end
    end
  end
end