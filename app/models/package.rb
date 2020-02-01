class Package < ApplicationRecord
	PACKAGE_URL = 'https://cran.r-project.org/src/contrib'.freeze
	PACKAGE_FILE = "#{PACKAGE_URL}/PACKAGES".freeze

	validates_presence_of :package_name, :version
	validates_uniqueness_of :package_name, scope: :version

	has_many :contributors_packages
	has_many :contributors, through: :contributors_packages

	def create_contributor description, role
		data = {
						name: description[/^[^\<\[]*/].strip,
						email: description[/\<(.*?)\>/,1]
					 }
		contributor = Contributor.create(data)
		ContributorsPackage.create(package: self, contributor: contributor, role: role)
	end

	def authors
		contributors.includes(:contributors_packages).where('contributors_packages.role': 'Author')
	end

	def maintainers
		contributors.includes(:contributors_packages).where('contributors_packages.role': 'Maintainer')
	end
end
