#! /bin/bash

# if no argument provided
if [[ -z $1 ]]
then
  # ask for argument
  echo "Please provide an element as an argument."
else
  # query matching number, symbol or name
  PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
  QUERY="SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING (atomic_number) FULL JOIN types USING (type_id)"
  
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    # query matching atomic number
    IFS='|' read NUMBER NAME SYMBOL TYPE MASS MELTING BOILING <<< $($PSQL "$QUERY WHERE atomic_number=$1;")
  else
    # query matching symbol or name
    IFS='|' read NUMBER NAME SYMBOL TYPE MASS MELTING BOILING <<< $($PSQL "$QUERY WHERE symbol='$1' OR name='$1';")
  fi

  # if no match found
  if [[ -z $NUMBER ]]
  then
    # say no match found
    echo "I could not find that element in the database."
  else
    # match found, show element information
    echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  fi

fi
