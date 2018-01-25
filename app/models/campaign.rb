class Campaign < ApplicationRecord
  belongs_to :user
  has_many :members, dependent: :destroy #one campaign has many member, dependent according remove

 #before create call method set_status in pending
  before_create :set_status
  #before create call method
  before_create :set_member
  enum status: [:pending, :finished]
  validates :title, :description, :user, :status, presence: true

  def set_status
    self.status = :pending # when not do raffle
  end

  #when create campaign always is a member
  def set_member
    #create a member and associated a campaign
    self.members << Member.create(name: self.user.name, email: self.user.email)
  end

end
