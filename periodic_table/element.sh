#!/bin/bash
#script to provide periodic table properties given atomic number, symbol, or element name
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
  exit
fi

#check if input not a number
if [[ ! $1 =~ ^[0-9]+$ ]]
then
  #check if symbol provided
  if [[ $1 =~ ^[A-Z][a-z]{0,1}$ ]]
  then
    ELEMENT_QUERY=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE symbol='$1';")
  else
    #name was provided
    ELEMENT_QUERY=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE name='$1';")
  fi
else
  #atomic number was provided
  ELEMENT_QUERY=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number=$1;")
fi

if [[ -z $ELEMENT_QUERY ]]
then
  echo -e "I could not find that element in the database."
else
  IFS="|" read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE <<< $ELEMENT_QUERY
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
fi