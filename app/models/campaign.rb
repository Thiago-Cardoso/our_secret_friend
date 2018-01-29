class Campaign < ApplicationRecord


 #before create call method set_status in pending
  before_validation :set_status, on: :create
  #before create call method
  before_validation :set_member, on: :create

  belongs_to :user
  has_many :members, dependent: :destroy #one campaign has many member, dependent according remove
  enum status: [:pending, :finished]
  validates :title, :description, :user, :status, presence: true

  #query for number of members
  def count_opened
   self.members.where(open: true).count
  end

  private

  def set_status
    self.status = :pending # when not do raffle
  end

  #when create campaign always is a member
  def set_member
    #create a member and associated a campaign
    self.members << Member.create(name: self.user.name, email: self.user.email)
  end

end
