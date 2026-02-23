class StatTracker
  attr_reader :all_data, :games, :game_teams, :teams

  def initialize(all_data)
    @all_data = all_data
    @games = []
    @teams = []
    @game_teams = []
    create_games
    create_teams
    create_game_teams
  end

  
  def highest_total_score
    # Highest sum of the winning and losing teams’ scores
    # return Integer
  end
  
  def lowest_total_score
    # Lowest sum of the winning and losing teams’ scores
    # return Integer
  end
  
  def percentage_home_wins
    # Percentage of games that a home team has won (rounded to the nearest 100th)
    # return Float
  end
  
  def percentage_visitor_wins
    # Percentage of games that a visitor has won (rounded to the nearest 100th)
    # return Float
  end
  
  def percentage_ties
    # Percentage of games that has resulted in a tie (rounded to the nearest 100th)
    # return Float
  end
  
  def count_of_games_by_season
    # A hash with season names (e.g. 20122013) as keys and counts of games as values
    # return Hash
  end
  
  def average_goals_per_game 
    # Average number of goals scored in a game across all seasons including both home and away goals (rounded to the nearest 100th)
    # Float
  end
  
  def average_goals_by_season
    # Average number of goals scored in a game organized in a hash with season names (e.g. 20122013)
    # as keys and a float representing the average number of goals in a game for that season as values 
    # (rounded to the nearest 100th)
    # Hash
  end
  
  def create_games
    @all_data[:games].each do |row|
       game = Game.new(row[:game_id],
                      row[:season],
                      row[:away_goals],
                      row[:home_goals], 
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
                      row[:goals], 
                      row[:hoa].strip, 
                      row[:result],
                      row[:tackles],
                      row[:head_coach],
                      row[:shots]
                      )
      @game_teams << game_team
    end
    @game_teams
  end
  
  def self.from_csv(locations)
    all_data = {}
    locations.each do |file_name, location|
      formatted_csv = CSV.open location, headers: true, header_converters: :symbol
      all_data[file_name] = formatted_csv
    end
    StatTracker.new(all_data)
  end
end