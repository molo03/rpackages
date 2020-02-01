require 'dcf'
require 'rubygems/package'
require 'zlib'

namespace :packages do
	desc 'Extracts all package information from CRAN server'
	task :index_data, [:schedule]  => :environment do |task, args|
		begin
			package_to_do = 50 # limit the extracted packages to 50
			packages = Array.new

			package_contents = URI.open(Package::PACKAGE_FILE) { |f| f.read }
			packages = Dcf.parse package_contents
			unless args[:schedule] == 'daily'
				packages = packages[0..(package_to_do - 1)]
			else
			packages.each_with_index do |p, i|
				package_data = {
					package_name: p['Package'].to_s,
					version: p['Version'].to_s,
					publication_date: '',
					title: '',
					description: ''
				}
				contributors = Array.new
				puts "#{Package::PACKAGE_URL}/#{package_data[:package_name]}_#{package_data[:version]}.tar.gz"
				package_file = URI.open("#{Package::PACKAGE_URL}/#{package_data[:package_name]}_#{package_data[:version]}.tar.gz")
				if package_file.is_a? StringIO
					tempfile = Tempfile.new
					File.write(tempfile.path, package_file.read)
					package_file = tempfile
				end
				package_extract = Gem::Package::TarReader.new(Zlib::GzipReader.open(package_file))
				package_extract.rewind
				package_extract.each do |file|
					if file.full_name.split('/').last == 'DESCRIPTION'
						desc_contents = file.read
						descriptions = (Dcf.parse desc_contents).first
						package_data[:publication_date] = Date.parse(descriptions['Date/Publication'].to_s)
						package_data[:title] = descriptions['Title'].to_s
						package_data[:description] = descriptions['Description'].to_s
						package = Package.create package_data
						next unless package.valid?

						descriptions['Author'].to_s.split(',').each do |author|
							package.create_contributor(author, 'Author')
						end
						descriptions['Maintainer'].to_s.split(',').each do |maintainer|
							package.create_contributor(maintainer, 'Maintainer')
						end
					end
				end
			end
		rescue Exception => e
			puts "Error: " + e.message
		end
	end
end