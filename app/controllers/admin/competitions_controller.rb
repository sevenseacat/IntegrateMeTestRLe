class Admin::CompetitionsController < Admin::ApplicationController
  def app
    @competitions = Competition.recent_first
    @mailing_lists = MailingList.all
  end

  def update
    competition = Competition.find params[:id]
    if competition.update(competition_params)
      render json: { competition: competition, errors: {} }
    else
      render json: { competition: nil, errors: competition.errors }
    end
  end

  private

  def competition_params
    params.require(:competition).permit(:name, :requires_entry_name, :mailing_list_id)
  end
end
