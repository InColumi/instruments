# /bin/bash

FILE_NAME=$1
FIRST_COMMIT=$2
SECOND_COMMIT=$3
git archive --output=$FILE_NAME $FIRST_COMMIT "$(git diff --name-only $FIRST_COMMIT $SECOND_COMMIT)"
