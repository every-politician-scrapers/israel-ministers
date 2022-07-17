#!/bin/bash

cd $(dirname $0)

jq -r '.GovermentPositions[] | [.ID, .MkName, .PositionName, .StartDate, .FinishDate] | @csv' 36.json |
  sed -e 's/T00:00:00//g' |
  qsv rename -n id,itemLabel,positionLabel,startDate,endDate |
  qsv search -s endDate -v . |
  sed -E 's/ *,/,/g' > scraped.csv
wd sparql -f csv wikidata.js | sed -e 's/T00:00:00Z//g' -e 's#http://www.wikidata.org/entity/##g' | qsv dedup -s psid > wikidata.csv
bundle exec ruby diff.rb | qsv sort -s itemlabel | tee diff.csv

cd ~-
