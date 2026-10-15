# Define variables
ARCHIVE_NAME = internet.db.zip
SOURCE_FILE = internet.db

# Declare phony targets
.PHONY: zip unzip clean server pack-split unpack-split example-search lists list-youtube list-github list-reddit

# Rule to create a zip archive split into 50MB parts

filter:
	poetry run python dbupdate.py --db internet.db --trunc-no-users --delete-redundant --trunc-search-data --truncate-table domains --trunc-configuration --trunc-dynamic-data --obfuscate

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
	rm -f internet*zip

server:
	python3 -m http.server 8000

summary: lists
	poetry run python dbanalyzer.py --tables --db $(SOURCE_FILE)

lists: list-youtube list-github list-github-ai list-reddit list-rss-youtube list-awesome-links list-ai
list-youtube:
	poetry run python ./dbanalyzer.py --db internet.db --search "link=*youtube.com/channel*" --title --social --tags --order-by page_rating_votes --order-by "social__followers_count" --desc --json > lists/youtube.json
list-github:
	poetry run python ./dbanalyzer.py --db internet.db --search "link=*https://github.com/*" --order-by page_rating_votes --order-by "social__stars" --desc > lists/github.links
list-reddit:
	poetry run python ./dbanalyzer.py --db internet.db --search "link=*https://reddit.com/r/*" --order-by page_rating_votes --order-by "social__followers_count" --desc > lists/reddit.links

list-rss-youtube:
	poetry run python ./dbanalyzer.py --db internet.db --search "link=*youtube.com/channel*" --title --social --tags --rss  --order-by page_rating_votes --order-by "social__followers_count" --desc --json > lists/rss_youtube.json

list-github-ai:
	poetry run python ./dbanalyzer.py --db internet.db --search "link=*https://github.com/* & tags__tag=*artificial intel*" --order-by page_rating_votes --order-by "social__stars" --desc > lists/github_ai.links

list-awesome-links:
	poetry run python ./dbanalyzer.py --db internet.db --search "tags__tag=*awesome list*" --order-by page_rating_votes --order-by "social__stars" --desc > lists/awesome.links

list-ai:
	poetry run python ./dbanalyzer.py --db internet.db --search "tags__tag=*artificial intel*" --order-by page_rating_votes --order-by "social__stars" --desc > lists/ai.links


example-search1:
	poetry run python ./dbanalyzer.py --db internet.db --search "*Warhammer*" --tags --social --title --description --status
example-search2:
	poetry run python ./dbanalyzer.py --db internet.db --search "*youtube.com/channel*" --title --tags --social

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

