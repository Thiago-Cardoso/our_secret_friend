class CampaignMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.campaign_mailer.raffle.subject
  #
  def raffle(campaign, member, friend)
    @campaign = campaign
    @member = member
    @friend = friend
    mail to: @member.email, subject: "Nosso Amigo Secreto: #{@campaign.title}"
  end

  def raffle_error(campaign)
    @campaign = campaign
    mail to: @campaign.user.email, subject: "Erro no sorteio do Nosso Amigo Secreto: #{@campaign.title}"
  end
end
