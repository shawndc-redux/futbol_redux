class GameTeam 
  attr_reader :game_id, :team_id, :HoA, :result, :settled_in, :head_coach, :goals, :shots, :tackles, :pim, :powerPlayOpportunities, :powerPlayGoals, :faceOffWinPercentage, :giveaways, :takeaways

  def initialize
    @game_id = game_id
    @team_id = team_id
    @HoA = hoa 
    @result = result
    @settled_in = settled_in
    @head_coach = head_coach
    @goals = goals
    @shots = shots
    @tackles = tackles
    @pim = pim 
    @powerPlayOpportunities = powerPlayOpportunities
    @powerPlayGoals = powerPlayGoals
    @faceOffWinPercentage = faceOffWinPercentage
    @giveaways = giveaways
    @takeaways = takeaways
  end
end