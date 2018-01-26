class Member < ApplicationRecord
  belongs_to :campaign
  after_save :set_campaign_pending
  #it is required, name, email, campaign
  validates :name, :email, :campaign, presence: true

#look the email is open
#token url variable is randon
  def set_pixel
   self.open = false
   self.token = loop do
     #if exist a member with the same token raffle the other else if member exist break
     random_token = SecureRandom.urlsafe_base64(nil, false)
     break random_token unless Member.exists?(token: random_token)
   end
   self.save!
 end

  protected

  def set_campaign_pending
    #after the save update campaign for status pending
    self.campaign.update(status: :pending)
  end

end
