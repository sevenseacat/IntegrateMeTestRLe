class Admin::CompetitionsController < Admin::ApplicationController
  def index
    @competitions = Competition.recent_first
  end
end
