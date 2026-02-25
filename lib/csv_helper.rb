module CsvHelper
  def create_games
    @all_data[:games].each do |row|
       game = Game.new(row[:game_id],
                      row[:season],
                      row[:away_goals].to_i,
                      row[:home_goals].to_i, 
                      row[:away_team_id], 
                      row[:home_team_id] 
                      )
      @games << game
    end
    @games
  end
  
  def create_teams
    @all_data[:teams].each do |row|
      team = Team.new(row[:team_id], row[:teamname])
      @teams << team
    end
    @teams
  end
  
  def create_game_teams
    @all_data[:game_teams].each do |row|
      game_team = GameTeam.new(row[:game_id],
                      row[:team_id],
                      row[:goals].to_i, 
                      row[:hoa].strip, 
                      row[:result],
                      row[:tackles].to_i,
                      row[:head_coach],
                      row[:shots].to_i
                      )
      @game_teams << game_team
    end
    @game_teams
  end
end