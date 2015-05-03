class Team < ActiveRecord::Base
	belongs_to :pillar
	has_many :projects

	validates :name, presence: true, uniqueness: true
	validates :pillar_id, presence: true
end
