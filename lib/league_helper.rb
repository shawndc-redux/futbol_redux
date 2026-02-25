module LeagueHelper
  def total_games_per_team(game_teams)
    game_teams.map {|gt| gt.team_id}.tally
  end

  def all_goals_per_team(game_teams)
    team_goals = {}

    game_teams.map do |game_team| 
      if !team_goals.keys.include?(game_team.team_id)
        team_goals[game_team.team_id] = game_team.goals
      else
        team_goals[game_team.team_id] += game_team.goals
      end
    end

    team_goals
  end

  def total_season_goals
    goals = {}

    @games.map do |game|
      if !goals.keys.include?(game.season)
        goals[game.season] = (game.away_goals + game.home_goals)
      else
        goals[game.season] += (game.away_goals + game.home_goals)
      end
    end

    goals
  end
end