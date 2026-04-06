#!/bin/bash
#number guessing game
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))

echo "Enter your username:"
read USERNAME
USER_QUERY=$($PSQL "SELECT games_played, best_guess FROM users WHERE username='$USERNAME';")
if [[ -z $USER_QUERY ]]
then
  #init user
  GAMES_PLAYED=0
  BEST_GAME=0
  $($PSQL "INSERT INTO users(username, games_played, best_guess) VALUES('$USERNAME', $GAMES_PLAYED, $BEST_GAME);") 2> /dev/null
  echo "Welcome, $USERNAME! It looks like this is your first time here."
else
  #display user info
  IFS="|" read GAMES_PLAYED BEST_GAME <<< $USER_QUERY
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

echo "Guess the secret number between 1 and 1000:"
read USER_GUESS
GUESS_AMT=1
while [[ $USER_GUESS != $SECRET_NUMBER ]]
do
  if [[ ! $USER_GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
  elif [[ $USER_GUESS > $SECRET_NUMBER ]]
  then
    echo "It's lower than that, guess again:"
  else
    echo "It's higher than that, guess again:"
  fi
  read USER_GUESS
  GUESS_AMT=$(( $GUESS_AMT + 1 ))
done

GAMES_PLAYED=$(( $GAMES_PLAYED + 1 ))
$($PSQL "UPDATE users SET games_played = $GAMES_PLAYED WHERE username='$USERNAME';") 2> /dev/null
if (( BEST_GAME == 0 || GUESS_AMT < BEST_GAME ))
then
  $($PSQL "UPDATE users SET best_guess = $GUESS_AMT WHERE username='$USERNAME';") 2> /dev/null
fi
echo "You guessed it in $GUESS_AMT tries. The secret number was $SECRET_NUMBER. Nice job!"