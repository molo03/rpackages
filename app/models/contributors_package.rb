class ContributorsPackage < ApplicationRecord
	validates_presence_of :role
	
	belongs_to :contributor
	belongs_to :package
end
