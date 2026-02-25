module SeasonHelper
  def average_goals_by_team(game_teams)
    team_goals = all_goals_per_team(game_teams)
    ttl_team_games = total_games_per_team(game_teams)
    team_avgs = {}

    team_goals.map do |k, v|
      team_avgs[@teams.find {|team| team.team_id == k}.team_name] = (v.to_f/(ttl_team_games[k].to_f)).round(2)
    end
    team_avgs
  end
  
  def team_wins_totals(gts)
    wins_totals = {} # wins_totals[coach] = [wins, total]

    gts.each do |gt|
      if !wins_totals.keys.include?(gt.head_coach) && gt.result == "WIN"
        wins_totals[gt.head_coach] = [1, 0]
      elsif !wins_totals.keys.include?(gt.head_coach) && gt.result != "WIN"
        wins_totals[gt.head_coach] = [0, 0]
      elsif wins_totals.keys.include?(gt.head_coach) && gt.result == "WIN"
        wins_totals[gt.head_coach][0] += 1
      end
      wins_totals[gt.head_coach][1] += 1
    end

    wins_totals
  end

  def season_game_teams(season_id)
    @game_teams.find_all {|gt| gt.game_id[0,4] == season_id[0,4]}
  end

  def team_win_percentages(season_id)
    gts = season_game_teams(season_id)
    percentages = {}
    wins_totals = team_wins_totals(gts) # wins[coach] = [wins, total]

    wins_totals.each do |coach, win_total|
      percentages[coach] = (win_total[0].to_f/win_total[1].to_f)
    end

    percentages
  end

  def team_goal_shots(game_teams)
    tgs = {}
    game_teams.each do |gt|
      if tgs[gt.team_id].nil?
        tgs[gt.team_id] = []
        tgs[gt.team_id][0] = gt.goals
        tgs[gt.team_id][1] = gt.shots
      else
        tgs[gt.team_id][0] += gt.goals
        tgs[gt.team_id][1] += gt.shots
      end
    end

    tgs
  end

  def team_goal_shots_ratios(game_teams)
    tgs_ratios = {} 
    team_goal_shots(game_teams).each { |team, goal_shots| tgs_ratios[team] = (goal_shots[0].to_f/goal_shots[1].to_f)}

    tgs_ratios
  end

  def team_tackles(game_teams)
    teams_tackles = {}
    game_teams.each do |gt|
      if teams_tackles[gt.team_id].nil?
        teams_tackles[gt.team_id] = gt.tackles
      else
        teams_tackles[gt.team_id] += gt.tackles
      end
    end

    teams_tackles
  end
end
