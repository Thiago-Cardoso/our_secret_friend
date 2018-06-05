require 'rails_helper'

describe RaffleService do

  before :each do
    @campaign = create(:campaign, status: :pending)
  end

  describe '#call' do
    context "when has more then two members" do
      before(:each) do
        create(:member, campaign: @campaign)
        create(:member, campaign: @campaign)
        create(:member, campaign: @campaign)
        @campaign.reload

        #create new object
        @results = RaffleService.new(@campaign).call
      end

      #test if you return is hash
      it "results is a hash" do
        expect(@results.class).to eq(Hash)
      end

      # all member campaign show with member
      it "all members are in results as a member" do
        result_members = @results.map {|r| r.first}
        expect(result_members.sort).to eq(@campaign.members.sort)
      end

      #if all member participate
      it "all member are in results as a friend" do
        result_friends = @results.map {|r| r.last}
        expect(result_friends.sort).to eq(@campaign.members.sort) #ordener array and compare
      end

      it "a member don't get yourself" do
        @results.each do |r|
          #get first
          expect(r.first).not_to eq(r.last) #get last
        end
      end

      it "a member x don't get a member y that get the member x" do
        # Desafio
        @results.each do |r|
          #get first
          expect(r.first == r.last).to eq(false)
        end
      end

    end

    context "when don't has more then two members" do
      before(:each) do
        create(:member, campaign: @campaign)
        @campaign.reload

        @response = RaffleService.new(@campaign).call
      end

      it "raise error" do
        expect(@response).to eql(false)
      end
    end
  end
end
