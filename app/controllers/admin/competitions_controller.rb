class Admin::CompetitionsController < Admin::ApplicationController
  def app
    @competitions = Competition.recent_first
  end
end
