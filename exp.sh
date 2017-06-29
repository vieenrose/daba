#! /bin/bash

#set -vx

GIT_VERSION="$(git rev-parse HEAD)"
NOM=exp_$(date +%H_%M_%S)_"$GIT_VERSION"

BASIC_OPTIONS="-v -t -l $NOM.mod"
SUPP_OPTIONS="-e 1 --filtering"

KEYWORD="Seconds required for this iteration: |Error norm|Iteration #"
KEYWORD2="diacritic_only|chunkmode|filtering|no_coding|no_decomposition|r_E|accuracy|done"
FP_PAT="[-+]?[0-9]+\.?[0-9]*"

for d in "--diacritic_only" "--diacritic_only --no_decomposition" "" "--no_decomposition"
do
for w in -1 1 2 3 4 5 6 7 0
do
VAR_OPTS="-c $w $d"

gstdbuf -oL python disambiguation.py $VAR_OPTS $SUPP_OPTIONS $BASIC_OPTIONS \
| gawk "BEGIN{IGNORECASE=1} /.*($KEYWORD2).*/ {print \$0} match(\$0, /.*($KEYWORD)[^.0-9+-]*($FP_PAT)/, ary) {print ary[2]}" \
>> "$NOM.log" \ || \
stdbuf -oL python disambiguation.py $VAR_OPTS $SUPP_OPTIONS $BASIC_OPTIONS \
| gawk "BEGIN{IGNORECASE=1} /.*($KEYWORD2).*/ {print \$0} match(\$0, /.*($KEYWORD)[^.0-9+-]*($FP_PAT)/, ary) {print ary[2]}" \
>> "$NOM.log"
done
done
