require 'game_helper'
require 'league_helper'
require 'season_helper'
require 'csv_helper'

class StatTracker
  include GameHelper
  include LeagueHelper
  include SeasonHelper
  include CsvHelper
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

  def self.from_csv(locations)
    all_data = {}
    locations.each do |file_name, location|
      formatted_csv = CSV.open location, headers: true, header_converters: :symbol
      all_data[file_name] = formatted_csv
    end
    StatTracker.new(all_data)
  end

  # GAME STATISTICS
  # *****************************
  def highest_total_score # Highest sum of the winning and losing teams’ scores
    total_game_goals.max
  end
  
  def lowest_total_score # Lowest sum of the winning and losing teams’ scores
    total_game_goals.min
  end
  
  def percentage_home_wins # Percentage of games that a home team has won (rounded to the nearest 100th)
    result_percentages("WIN")
  end
  
  def percentage_visitor_wins # Percentage of games that a visitor has won (rounded to the nearest 100th)
    result_percentages("LOSS")
  end
  
  def percentage_ties # Percentage of games that has resulted in a tie (rounded to the nearest 100th)
    result_percentages("TIE")
  end
  
  def count_of_games_by_season # A hash with season names (e.g. 20122013) as keys and counts of games as values    
    @games.map {|game| game.season}.tally
  end
  
  def average_goals_per_game # Average number of goals scored in a game across all seasons including both home and away goals (rounded to the nearest 100th)
    (total_game_goals.sum.to_f/total_game_goals.count.to_f).round(2)
  end
  
  def average_goals_by_season
    average_goals = total_season_goals
    average_goals.map do |season, goals|
      average_goals[season] = (goals.to_f/count_of_games_by_season[season].to_f).round(2)
    end

    average_goals
  end

  # LEAGUE STATISTICS
  # *****************************
  def count_of_teams
    @teams.count
  end

  def best_offense # find avg # of goals scored /game for all teams
    average_goals_by_team(@game_teams).max_by {|k, v| v}[0]
  end

  def worst_offense
    average_goals_by_team(@game_teams).min_by {|k, v| v}[0]
  end

  def highest_scoring_visitor
    visitor_games = @game_teams.find_all {|game_team| game_team.hoa == "away" }
    average_goals_by_team(visitor_games).max_by {|k, v| v}[0]
  end

  def highest_scoring_home_team
    home_games = @game_teams.find_all {|game_team| game_team.hoa == "home" }
    average_goals_by_team(home_games).max_by {|k, v| v}[0]
  end

  def lowest_scoring_visitor
    home_games = @game_teams.find_all {|game_team| game_team.hoa == "away" }
    average_goals_by_team(home_games).min_by {|k, v| v}[0]
  end

  def lowest_scoring_home_team
    home_games = @game_teams.find_all {|game_team| game_team.hoa == "home" }
    average_goals_by_team(home_games).min_by {|k, v| v}[0]
  end

  # SEASON STATISTICS
  # *****************************
  def winningest_coach(season_id) # coach with best win percentage
    @game_teams.find {|gt| gt.head_coach == team_win_percentages(season_id).key(team_win_percentages(season_id).values.max)}.head_coach
  end

  def worst_coach(season_id) # coach with worst win percentage
    @game_teams.find {|gt| gt.head_coach == team_win_percentages(season_id).key(team_win_percentages(season_id).values.min)}.head_coach
  end

  def most_accurate_team(season_id) # Team with the best ratio of shots to goals for the season
    game_teams = season_game_teams(season_id)
    tgs_ratios = team_goal_shots_ratios(game_teams)

    @teams.find {|team| team.team_id == tgs_ratios.max_by {|k, v| v}[0]}.team_name
  end

  def least_accurate_team(season_id) # Team with the worst ratio of shots to goals for the season
    game_teams = season_game_teams(season_id)
    tgs_ratios = team_goal_shots_ratios(game_teams)

    @teams.find {|team| team.team_id == tgs_ratios.min_by {|k, v| v}[0]}.team_name
  end

  def most_tackles(season_id) # Name of the Team with the most tackles in the season
    game_teams = season_game_teams(season_id)
    teams_tackles = team_tackles(game_teams)

    @teams.find {|team| team.team_id == teams_tackles.max_by {|k, v| v}[0]}.team_name
  end

  def fewest_tackles(season_id)
    game_teams = season_game_teams(season_id)
    teams_tackles = team_tackles(game_teams)

    @teams.find {|team| team.team_id == teams_tackles.min_by {|k, v| v}[0]}.team_name
  end

  # CSV PARSING
  # *****************************
  
end