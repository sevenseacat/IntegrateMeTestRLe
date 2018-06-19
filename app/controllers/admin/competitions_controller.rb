class Admin::CompetitionsController < Admin::ApplicationController
  def index
    @competitions = Competition.all
  end
end
