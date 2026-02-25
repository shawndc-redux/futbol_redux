module GameHelper
    def result_percentages(result)
    all_results = @game_teams.find_all {|gt| gt.hoa == "home" }.map {|game| game.result}
    total = all_results.length
    for_specific_result = all_results.tally[result]
    (for_specific_result.to_f/total.to_f).round(2)
  end

  def total_game_goals
    @games.map { |game| game.home_goals + game.away_goals}
  end
end