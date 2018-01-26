class RaffleService
  def initialize(campaign)
    @campaign = campaign
  end

  def call
      #verification if exist 2 member in Raffle
    return false if @campaign.members.count < 3

    results = {}
    #all member possible raffle
    members_list = @campaign.members
    #all friend raffle
    friends_list = @campaign.members
    i = 0
    while(members_list.count != i)
      m = members_list[i]
      i += 1

      loop do
        friend = friends_list.sample

        #try get friend cannot Raffle or member now
        if friends_list.count == 1 and friend == m
          results = {}
          members_list = @campaign.members
          friends_list = @campaign.members
          break
          #you cannot Raffle himself
        elsif friend != m and results[friend] != m
          results[m] = friend
          friends_list -= [friend]
          break
        end
      end
    end
    results
  end
end
