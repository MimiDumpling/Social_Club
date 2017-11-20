class Payment < ApplicationRecord
	belongs_to :user

	validates :token, presence: true
	validates :user_id, presence: true
	validates :last_4, presence: true
end
