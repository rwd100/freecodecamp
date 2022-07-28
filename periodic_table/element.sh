#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
echo  "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUM=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
  else
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol ILIKE '$1'")
  NAME=$($PSQL "SELECT name FROM elements WHERE name ILIKE '$1'")
  fi
  if [[ -z $ATOMIC_NUM && -z $SYMBOL && -z $NAME ]]
  then
    echo 'I could not find that element in the database.'
  else
    if [[ ! -z $ATOMIC_NUM ]]
    then
      pro=$($PSQL "SELECT name,symbol, atomic_number, type , atomic_mass , melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN types USING(type_id) INNER JOIN elements USING(atomic_number) WHERE atomic_number = $1 ")
      echo $pro | while read NAME BAR SYMBOL BAR ATOMIC_NUM BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
      do
        echo "The element with atomic number $ATOMIC_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
    fi
    if [[ ! -z $SYMBOL ]]
    then
      pro=$($PSQL "SELECT name,symbol, atomic_number, type , atomic_mass , melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN types USING(type_id) INNER JOIN elements USING(atomic_number) WHERE symbol ILIKE '$1' ")
      echo $pro | while read NAME BAR SYMBOL BAR ATOMIC_NUM BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
      do
        echo "The element with atomic number $ATOMIC_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
    fi
    if [[ ! -z $NAME ]]
    then
      pro=$($PSQL "SELECT name,symbol, atomic_number, type , atomic_mass , melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN types USING(type_id) INNER JOIN elements USING(atomic_number) WHERE name ILIKE '$1' ")
      echo $pro | while read NAME BAR SYMBOL BAR ATOMIC_NUM BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
      do
        echo "The element with atomic number $ATOMIC_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
    fi
    
  fi
fi