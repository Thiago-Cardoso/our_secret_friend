class CampaignsController < ApplicationController
  before_action :authenticate_user! #required user logged

  #set campaign
  before_action :set_campaign, only: [:show, :destroy, :update, :raffle]
  before_action :is_owner?, only: [:show, :destroy, :update, :raffle]

  def show
  
  end

  def index
      #List of Campaign
     @campaigns = current_user.campaigns
  end

  #create
  def create
     @campaign = Campaign.new(user: current_user, title: 'Nova Campanha', description: 'Descreva sua campanha...')

    respond_to do |format|
      if @campaign.save
        format.html { redirect_to "/campaigns/#{@campaign.id}" }
      else
        format.html { redirect_to main_app.root_url, notice: @campaign.errors }
      end
    end
  end

  #update
  def update
    respond_to do |format|
      if @campaign.update(campaign_params)
        format.json { render json: true }
      else
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  #destroy
  def destroy
    @campaign.destroy

    respond_to do |format|
      format.json { render json: true }
    end
  end

  def raffle
    respond_to do |format|
      #if status campaign pending raffle
      if @campaign.status != "pending"
        format.json { render json: 'Já foi sorteada', status: :unprocessable_entity }
      elsif @campaign.members.count < 3
        format.json { render json: 'A campanha precisa de pelo menos 3 pessoas', status: :unprocessable_entity }
      else
        #call job
        CampaignRaffleJob.perform_later @campaign
        format.json { render json: true }
      end
    end
  end


  private

  #get params
  def set_campaign
    @campaign = Campaign.find(params[:id])
  end

  #passed parameters
  def campaign_params
    params.require(:campaign).permit(:title, :description, :event_date, :event_hour, :locale).merge(user: current_user)
  end

  #if user logged is owner of campaign
  def is_owner?
    unless current_user == @campaign.user
      respond_to do |format|
        format.json { render json: false, status: :forbidden }
        format.html { redirect_to main_app.root_url }
      end
    end
  end

end
