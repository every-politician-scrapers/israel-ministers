#!/bin/bash

jq -r '.GovermentPositions[] | [.ID, .PositionName, .MkName, .StartDate, .FinishDate] | @csv' mirror/36.json |
  sed -e 's/T00:00:00//g' |
  qsv rename -n id,position,name,start,end |
  qsv search -s end -v . |
  sed -E 's/ *,/,/g' |
  ifne tee data/official.csv

bundle exec ruby bin/scraper/wikidata.rb meta.json |
  sed -e 's/T00:00:00Z//g' |
  qsv dedup -s psid |
  ifne tee data/wikidata.csv

bundle exec ruby bin/diff.rb | tee data/diff.csv
