#!/usr/bin/env bash

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
