#!/bin/bash

cd $(dirname $0)

jq -r '.GovermentPositions[] | [.ID, .PositionName, .MkName, .StartDate, .FinishDate] | @csv' 36.json |
  sed -e 's/T00:00:00//g' |
  qsv rename -n id,position,name,start,end |
  qsv search -s end -v . |
  sed -E 's/ *,/,/g' > scraped.csv
bundle exec ruby wikidata.rb meta.json | sed -e 's/T00:00:00Z//g' | qsv dedup -s psid > wikidata.csv
bundle exec ruby diff.rb | tee diff.csv

cd ~-
