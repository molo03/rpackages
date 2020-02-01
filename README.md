# README

* Ruby version
	Ruby version 2.7.0

* Setup
	
	1. bundle install
	2. rails db:create
	3. rails db:migrate

* Initial indexed data

	Run the following rake task:

	rails packages:index_data

	This will index the first 50 packages from the PACKAGES file in the CRAN Server

* Add daily indexing task to cronjob

	1. crontab -e
	2. Add the following line:
		0 12 * * * cd (project location); rails packages:index_data['daily']