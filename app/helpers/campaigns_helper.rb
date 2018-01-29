module CampaignsHelper
  def open_number(campaign)
    #calculate how many member is in campain and count quantity member
    "#{campaign.count_opened}/#{campaign.members.count}" #call method in model count_opened
  end
end
