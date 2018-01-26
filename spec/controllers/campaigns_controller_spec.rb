require 'rails_helper'

RSpec.describe CampaignsController, type: :controller do
include Devise::Test::ControllerHelpers #include test for devise with helper of devise

  before(:each) do
  # request.env["HTTP_ACCEPT"] = 'application/json'

  @request.env["devise.mapping"] = Devise.mappings[:user] #mapping devise
  @current_user = FactoryBot.create(:user) #create user utilizing factory user
  sign_in @current_user #do sign with
  end

  describe "GET #show" do
    #if campaign exists and owner
   context "campaing exists" do
     context "User is the owner of the campaing" do
       it "Returns success" do
          campaign = create(:campaign, user: @current_user) #campaign create passed user
          get :show, params: {id: campaign.id} #get action show controller campaign
          expect(response).to have_http_status(:success) #suceess
        end
      end

      #if user ir not the owner exists of the campaign
      context "User is not the owner of the campaign" do
        it "Redirects to root" do
          campaign = create(:campaign)
          get :show, params: {id: campaign.id}
          expect(response).to redirect_to('/')
        end
      end
    end

    #if campaign don't exists
    context "campaign don't exists" do
      it "Redirects to root" do
        get :show, params: {id: 0} #redirect
        expect(response).to redirect_to('/')
      end
    end
  end

  describe "GET #index" do #verificate if return sucess
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #create" do
    before(:each) do
      #create atributes for campaign
     @campaign_attributes = attributes_for(:campaign, user: @current_user)
     post :create, params: {campaign: @campaign_attributes} #do a post
    end

    #redirect for campaign now
    it "Redirect to new campaign" do
      expect(response).to have_http_status(302)
      expect(response).to redirect_to("/campaigns/#{Campaign.last.id}")
    end

    #create campaign with data fixed
    it "Create campaign with right attributes" do
      expect(Campaign.last.user).to eql(@current_user)
      expect(Campaign.last.title).to eql(@campaign_attributes[:title])
      expect(Campaign.last.description).to eql(@campaign_attributes[:description])
      expect(Campaign.last.status).to eql('pending')
    end

    #create campaign with member associeted
    it "Create campaign with owner associated as a member" do
      expect(Campaign.last.members.last.name).to eql(@current_user.name)
      expect(Campaign.last.members.last.email).to eql(@current_user.email)
    end
  end

  describe "GET #update" do
    it "returns http success" do
      get :update
      expect(response).to have_http_status(:success)
    end
  end

    describe "DELETE #destroy" do
     before(:each) do
       request.env["HTTP_ACCEPT"] = 'application/json' #set all with json
     end

     context "User is the Campaign Owner" do
       it "returns http success" do
         campaign = create(:campaign, user: @current_user) #create campaign
         delete :destroy, params: {id: campaign.id} #delete campaign
         expect(response).to have_http_status(:success) #redirect
       end
     end

     context "User isn't the Campaign Owner" do
       it "returns http forbidden" do
         campaign = create(:campaign)
         delete :destroy, params: {id: campaign.id}
         expect(response).to have_http_status(:forbidden)
       end
     end
   end

   escribe "PUT #update" do
    before(:each) do
      @new_campaign_attributes = attributes_for(:campaign)
      request.env["HTTP_ACCEPT"] = 'application/json'
    end

    context "User is the Campaign Owner" do
      before(:each) do
        campaign = create(:campaign, user: @current_user)
        put :update, params: {id: campaign.id, campaign: @new_campaign_attributes}
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "Campaign have the new attributes" do
        expect(Campaign.last.title).to eq(@new_campaign_attributes[:title])
        expect(Campaign.last.description).to eq(@new_campaign_attributes[:description])
      end
    end

    context "User isn't the Campaign Owner" do
      it "returns http forbidden" do
        campaign = create(:campaign)
        put :update, params: {id: campaign.id, campaign: @new_campaign_attributes}
        expect(response).to have_http_status(:forbidden)
      end
    end
  end


  describe "GET #raffle" do
    before(:each) do
      request.env["HTTP_ACCEPT"] = 'application/json'
    end

    context "User is the Campaign Owner" do
      before(:each) do
        @campaign = create(:campaign, user: @current_user)
      end

      context "Has more than two members" do
        before(:each) do
          #create 3 member associated a campaign
          create(:member, campaign: @campaign)
          create(:member, campaign: @campaign)
          create(:member, campaign: @campaign)
          post :raffle, params: {id: @campaign.id}
        end

        it "returns http success" do
          expect(response).to have_http_status(:success)
        end
      end

      context "No more than two members" do
        before(:each) do
          create(:member, campaign: @campaign)
          post :raffle, params: {id: @campaign.id}
        end

        it "returns http success" do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context "User isn't the Campaign Owner" do
      before(:each) do
        @campaign = create(:campaign) #create campaign
        post :raffle, params: {id: @campaign.id} #passed raffle
      end

      it "returns http forbidden" do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
