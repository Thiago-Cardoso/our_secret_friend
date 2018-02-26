class PagesController < ApplicationController
  def home
    #verification if user is logged
    if current_user
      @campaigns = current_user.campaigns
      # if exist any register campaign for user, redirect for campaign
        if @campaigns.any? == true
          redirect_to "/campaigns/"
        end
    end
  end

end
