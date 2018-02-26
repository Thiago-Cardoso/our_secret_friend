require 'rails_helper'

RSpec.describe CampaignRaffleJob, type: :job do
  #pending "add some examples to (or delete) #{__FILE__}"
    describe "#perform_later" do
    it "test of job" do
      ActiveJob::Base.queue_adapter = :test
      expect {
        CampaignRaffleJob.perform_later('emails')
      }.to have_enqueued_job
    end
  end
end
