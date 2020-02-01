class Contributor < ApplicationRecord
	validates_presence_of :name

	has_many :contributors_packages
	has_many :packages, through: :contributors_packages
end
