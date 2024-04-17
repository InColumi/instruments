# /bin/bash

OUTPUT_NAME=$1
FIRST_COMMIT=$2
SECOND_COMMIT=$3

LIST=$(git diff --name-only $FIRST_COMMIT $SECOND_COMMIT | tr " " "+" )
PATH_CHANGES=()

for a in $LIST; do
    PATH_CHANGES+=(\"${a//"+"/" "}\")
done

echo git archive --output=$OUTPUT_NAME $FIRST_COMMIT ${PATH_CHANGES[@]}
echo '---'
git archive --output=$OUTPUT_NAME $FIRST_COMMIT ${PATH_CHANGES[@]}
