require 'rails_helper'

RSpec.describe CampaignRaffleJob, type: :job do
  include ActiveJob::TestHelper

  let(:campaign) { create(:campaign) }
  let(:member) { create(:member, campaign: @campaign) }
  let(:friend) { create(:member, campaign: @campaign) }
  let(:mail) { CampaignMailer.raffle(@campaign, @member, @friend) }

  describe "#email job" do

    it "when send email for more one members" do
      ActiveJob::Base.queue_adapter = :test
      expect {
        CampaignRaffleJob.perform_later('raffle')
      }.to have_enqueued_job
    end
  end
end
