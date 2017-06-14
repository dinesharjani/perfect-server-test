#!/bin/bash

mkdir -p output
touch output/report.html
.build/debug/PerfectServerTest &
exec goaccess beaver.log -a > output/report.html --real-time-html
