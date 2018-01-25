require "rails_helper"

RSpec.describe CampaignMailer, type: :mailer do
  describe "raffle" do

        before do
          #create campaign
          @campaign = create(:campaign)
          #create member for campaing
          @member   = create(:member, campaign: @campaign)
          #send email
          @mail = CampaignMailer.raffle(@campaign, @member, @friend)
        end

        #test of header it is correct
        it "renders the headers" do
          expect(@mail.subject).to eq("Nosso Amigo Secreto: #{@campaign.title}")
          expect(@mail.to).to eq([@member.email])
        end

        it "body have member name" do
          expect(@mail.body.encoded).to match(@member.name)
        end

        it "body have campaign creator name" do
          expect(@mail.body.encoded).to match(@campaign.user.name)
        end

        it "body have member link to set open" do
          expect(@mail.body.encoded).to match("/members/#{@member.token}/opened")
        end
      end

end
