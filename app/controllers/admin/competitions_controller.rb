class Admin::CompetitionsController < Admin::ApplicationController
  def app
    @competitions = Competition.recent_first
    @mailing_lists = MailingList.all
  end
end
