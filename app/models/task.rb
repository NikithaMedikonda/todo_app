class Task < ApplicationRecord
  belongs_to :user

  validates :title, presence: { message: "Please fill required fields (Title)" }

  before_validation :set_default_status

  private

  def set_default_status
    self.status ||= 'pending'
  end
end

