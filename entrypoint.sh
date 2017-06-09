#!/bin/bash

exec .build/debug/PerfectServerTest &
exec goaccess -f beaver.log
