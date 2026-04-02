#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WIN_GOALS OPP_GOALS
do
  if [[ $YEAR != year ]]
  then
    #get team_id for winner
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    #if not found
    if [[ -z $TEAM_ID ]]
    then
      #insert team
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
      fi
    fi
    #get team_id for opponent
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
    #if not found
    if [[ -z $TEAM_ID ]]
    then
      #insert team
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
      fi
    fi
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WIN_GOALS OPP_GOALS
do
  if [[ $YEAR != year ]]
  then
    #get team_ids of winner and opponent
    WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")"
    OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")"
    #insert game data
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WIN_GOALS, $OPP_GOALS);")
    if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted $YEAR $ROUND with $WINNER winning with $WIN_GOALS goals and $OPPONENT having $OPP_GOALS goals.
    fi 
  fi
done