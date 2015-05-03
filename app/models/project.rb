class Project < ActiveRecord::Base
	belongs_to :team

	validates :name, presence: true, uniqueness: true
	validates :release_id, presence: true
	validates :team_id, presence: true
	validates :scope_id, presence: true
end
