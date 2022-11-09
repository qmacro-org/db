#!/usr/bin/env jq

def date: 
  sub(
    "^https.+?com/(?<yyyy>[0-9]{4})/(?<mm>[0-9]{2})/(?<dd>[0-9]{2})/.+$";
    "\(.yyyy)-\(.mm)-\(.dd)"
  );

