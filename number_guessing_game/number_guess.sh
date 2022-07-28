#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read USERNAME
USERNMAE_AVAILABLE=$($PSQL "SELECT username FROM users WHERE username = '$USERNAME'")


if [[ -z $USERNMAE_AVAILABLE ]]
then
  INSERT_USER=$($PSQL "INSERT INTO users(username) VALUES ('$USERNAME')")
  echo "Welcome, $USERNAME! It looks like this is your first time here."
else
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME'")
  GAMES_NUM=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id = $USER_ID")
  BEST_SCORE=$($PSQL "SELECT MIN(num_guesses) FROM games WHERE user_id = $USER_ID")
  echo "Welcome back, $USERNAME! You have played $GAMES_NUM games, and your best game took $BEST_SCORE guesses."
fi


SECRET_NUMBER=$((1 + $RANDOM % 1000))
echo "Guess the secret number between 1 and 1000:"
GUESSES_NUMBER=1
while read NUMBER
do
if [[ ! $NUMBER =~ ^[0-9]+$ ]]
then
  echo "That is not an integer, guess again: "
else
  if [[ $NUMBER -eq $SECRET_NUMBER ]]
  then
    break;
  elif [[ $NUMBER -gt $SECRET_NUMBER ]]
  then
    echo "It's lower than that, guess again:"
  else
    echo "It's higher than that, guess again:"
  fi  
fi
GUESSES_NUMBER=$(($GUESSES_NUMBER + 1))
done
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME'")
INSERT_GAME=$($PSQL "INSERT INTO games(user_id, num_guesses) VALUES ($USER_ID, $GUESSES_NUMBER)")
echo "You guessed it in $GUESSES_NUMBER tries. The secret number was $SECRET_NUMBER. Nice job!"