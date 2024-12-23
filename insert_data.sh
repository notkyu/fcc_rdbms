#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # insert into teams table: winner, opponent
  CHECK_WINNER_TEAMS=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
  CHECK_OPPONENT_TEAMS=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")

  if [[ $CHECK_WINNER_TEAMS != $WINNER && $WINNER != winner ]]
  then
    RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    if [[ $RESULT = "INSERT 0 1" ]]
    then
      echo Inserted opponent: $WINNER into teams table.
    fi
  fi

  if [[ $CHECK_OPPONENT_TEAMS != $OPPONENT && $OPPONENT != opponent ]]
  then
    RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    if [[ $RESULT = "INSERT 0 1" ]]
    then
      echo Inserted opponent: $OPPONENT into teams table.
    fi
  fi
  if [[ $WINNER != winner ]]
  then
    # insert into games table: year, round, winner_goals, opponent_goals
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    INSERT_RESULT=$($PSQL "INSERT INTO games(year,round,winner_goals,opponent_goals,winner_id,opponent_id) VALUES($YEAR, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS, $WINNER_ID, $OPPONENT_ID)")
    echo Inserted game: $ROUND, $WINNER vs $OPPONENT into games table.
  fi
done