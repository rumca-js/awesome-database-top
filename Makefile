# Define variables
ARCHIVE_NAME = internet.db.zip
SOURCE_FILE = internet.db

# Declare phony targets
.PHONY: zip unzip clean server pack-split unpack-split example-search

# Rule to create a zip archive split into 50MB parts
zip:
	zip $(ARCHIVE_NAME) $(SOURCE_FILE)
	echo "Packed $(SOURCE_FILE) into $(ARCHIVE_NAME)"
	rm -f $(SOURCE_FILE)

unzip:
	[ -e $(SOURCE_FILE) ] && rm -r $(SOURCE_FILE) || true
	7z x $(ARCHIVE_NAME)

unpack-split:
	cat internet* > $(ARCHIVE_NAME)
	7z x $(ARCHIVE_NAME)
	rm -f $(ARCHIVE_NAME)

# Clean rule to remove the archive
clean:
	rm -f internet.z*

server:
	python3 -m http.server 8000

summary:
	poetry run python dataanalyzer.py --summary --db $(SOURCE_FILE)

search-youtube:
	poetry run python ./dataanalyzer.py --db internet.db --search "*youtube.com/channel*" --rss

example-search1:
	poetry run python ./dataanalyzer.py --db internet.db --search "*Warhammer*" --tags --social --title --description --status
example-search2:
	poetry run python ./dataanalyzer.py --db internet.db --search "*youtube.com/channel*" --title --tags --social

remove-history:
	git checkout --orphan clean-main
	git commit -am "Clean start"
	git push origin clean-main

remove-history2:
	# Remove the history from 
	rm -rf .git
	
	# recreate the repos from the current content only
	git init
	git add .
	git brnach -m main
	git commit -m "Initial commit"
	
	# push to the github remote repos ensuring you overwrite history
	git remote add origin https://github.com/rumca-js/Internet-Places-Database.git
	git push -u --force origin main

filter:
	poetry run python filter.py --db internet.db --no-users --redundant --search-data --domains --obfuscate
