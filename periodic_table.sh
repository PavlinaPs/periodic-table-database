#!/bin/bash

# create PSQL variable
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# exit if there is no argument
if [[ -z $1 ]]
  then
    echo "Please provide an element as an argument."
    exit
fi

# if the input is a number, let's look in the db for atomic_number
if [[ $1 =~ ^[0-9]+$ ]]
  then 

  # get the information from the db
  DATA=$($PSQL "SELECT * FROM elements LEFT JOIN properties ON elements.atomic_number = properties.atomic_number LEFT JOIN types ON properties.type_id = types.type_id WHERE elements.atomic_number=$1")

  # exit if there is no such number in the db
  if [[ -z $DATA ]]
    then
    echo "I could not find that element in the database."
    exit
  fi

  echo $DATA | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME X ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE_ID Y TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done

  else
  # input is a string, let's check in the db
  DATA=$($PSQL "SELECT * FROM elements LEFT JOIN properties ON elements.atomic_number = properties.atomic_number LEFT JOIN types ON properties.type_id = types.type_id WHERE elements.symbol='$1' OR elements.name='$1'")

  # if there is no such number or string in the db
  if [[ -z $DATA ]]
    then
    echo "I could not find that element in the database."
    exit
  fi

  echo $DATA | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME X ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE_ID Y TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done

fi