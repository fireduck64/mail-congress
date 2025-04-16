#!/bin/bash


cat TextMailingLabel |tr "\t" "|"|cut -d "|" -f 2,4,5,6,7,8|tr "|" ","|grep -v "Office of the"|grep -v "FirstName" > house.csv

cat senators_cfm.xml | docker run -i --rm mikefarah/yq -o=json -p=xml .|jq . > senators.json

cat senators.json | jq .contact_information.member > senators-mem.json

jq --raw-output '
  .[]
  | [.first_name, .last_name, .address]
  | @csv
' senators-mem.json | tr -d "\"" | sed "s/ Washington DC 20510/,Washington,DC,20510/g" > senate.csv


echo "first,last,address,city,state,zip" | tr "[:lower:]" "[:upper:]" > full.csv
cat house.csv >> full.csv
cat senate.csv >> full.csv



