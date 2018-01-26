class CampaignRaffleJob < ApplicationJob
  queue_as :emails

  def perform(campaign)
  results = RaffleService.new(campaign).call

      campaign.members.each {|m| m.set_pixel}
      #send email for all
      results.each do |r|
        #send email hash(campain,member,friend)
        CampaignMailer.raffle(campaign, r.first, r.last).deliver_now #now send
      end
      campaign.update(status: :finished) #update campain

      #when return false or problem in server
    #if results == false
      # Send mail to owner of campaign (desafio)
    #end
  end
end
