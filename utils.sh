#!/usr/bin/env bash

list_issues() {

  local label="${1:?Specify label e.g. dj-adams-sap}"
  gh issue list \
    --limit 500 \
    --label "$label" \
    --json "number,title,body" 

}  

list_oldest_issues() {

  # Displays the three oldest (by post date) issues

  local label="${1:?Specify label e.g. dj-adams-sap}"

  list_issues "$label" \
  | jq 'import "utils" as utils; sort_by(.body|utils::date)|reverse|.[:3]'

}

de_entify() {

  local str
  read -r str < /dev/stdin
  echo "$str" \
  | sed '
    s/&#8211;/-/;
    s/&#8217;/'\''/;
    s/&#8230;/.../;
    s/&lt;/</;
    s/&gt;/>/;
    s/:/-/;
    '

}

get_title() {

  local url="${1:?Specify URL}"
  curl \
    --silent \
    --url "$url" \
    | grep \
      --perl-regexp \
      --only-matching \
      "(?<=<title>)(.+)(?= \| SAP Blogs)" \
    | de_entify

}


get_postdate() {

  # Pick out the yyyy mm and dd values from the URL and return
  # a yyyy-mm-dd postdate string.
  local url=$1
  echo "$url" \
    | sed -E 's|.+\.com/([0-9]{4})/([0-9]{2})/([0-9]{2})/.+|\1-\2-\3|'

}
