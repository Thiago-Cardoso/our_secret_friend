require 'rails_helper'

  RSpec.describe MembersController, type: :controller do
  include Devise::Test::ControllerHelpers #include test for devise with helper of devise

    before(:each) do
    request.env["HTTP_ACCEPT"] = 'application/json'

  @request.env["devise.mapping"] = Devise.mappings[:user] #mapping devise
  @current_user = FactoryBot.create(:user) #create user utilizing factory user
  sign_in @current_user #do sign with
  @campaign = create(:campaign, user: @current_user)
  @member = create(:member, campaign:  @campaign)
  end

  describe "GET #create" do
       context "when create verificate" do
          it "Creates new member and verificate if associated a campaign correct and return 200 sucess" do
            member = create(:member, campaign: @campaign)
            post :create, params: { member: { name: member.name, email: member.email, campaign_id: member.campaign_id} }
          end
          it "returns http success" do
            expect(response).to have_http_status(:success)
          end
        end

        context "User not have permission for add um member" do
          it "returns http forbidden" do
            member = create(:member)
            put :update, params: {id: member.id}
            expect(response).to have_http_status(:forbidden)
          end
        end

        #The method returned status 422
        context "email failer" do
          it "show message" do
            @member.save!
            expect{@member.dup.save!}.to raise_error('Validation failed: Email Este e-mail já foi adicionado a campanha')
          end
        end
    end


  describe "#DELETE" do

    context "when parameters not ok" do

      before(:each) do
        request.env["HTTP_ACCEPT"] = 'application/json'
      end

      it "member not found" do
        member = create(:member, campaign: @campaign)
        delete :destroy, params: {id: member.id}
        expect(response).to have_http_status(:success)
        delete :destroy, params: {id: member.id}
      end
    end
  end

end
