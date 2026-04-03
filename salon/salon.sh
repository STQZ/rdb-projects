#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~ Jonglenon Salon ~~~\n"

SALON_MENU () {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  else
    echo Welcome to Jonglenon Salon, how may I help you?
  fi
  echo -e "\n1) cut\n2) color\n3) style\n4) perm"
  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
    1) SCHEDULE_SERVICE 1 ;;
    2) SCHEDULE_SERVICE 2 ;;
    3) SCHEDULE_SERVICE 3 ;;
    4) SCHEDULE_SERVICE 4 ;;
    *) SALON_MENU "Jonglenon does not provide that service. What would you like today?" ;;
  esac
}

SCHEDULE_SERVICE () {
  if [[ $1 == 1 ]]
  then
    #cut
    SERVICE=$($PSQL "SELECT name FROM services WHERE service_id='$1';")
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    #check if customer exists
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE';")
    #remove spaces
    CUSTOMER_NAME=$(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')
    if [[ -z $CUSTOMER_NAME ]]
    then
      echo -e "\nWe don't have you in our records. What's your name?"
      read CUSTOMER_NAME
      #add customer
      CUSTOMER_INSERT_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME');")
    fi
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE' AND name='$CUSTOMER_NAME';")
    echo -e "\nWhat time would you like your cut, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')?"
    read SERVICE_TIME
    APPT_INSERT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")
    echo -e "\nI have put you down for a $(echo $SERVICE | sed -r 's/^ *| *$//g') at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."
  elif [[ $1 == 2 ]]
  then
    #color
    SERVICE=$($PSQL "SELECT name FROM services WHERE service_id='$1';")
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    #check if customer exists
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE';")
    #remove spaces
    CUSTOMER_NAME=$(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')
    if [[ -z $CUSTOMER_NAME ]]
    then
      echo -e "\nWe don't have you in our records. What's your name?"
      read CUSTOMER_NAME
      #add customer
      CUSTOMER_INSERT_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME');")
    fi
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE' AND name='$CUSTOMER_NAME';")
    echo -e "\nWhat time would you like your color, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')?"
    read SERVICE_TIME
    APPT_INSERT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")
    echo -e "\nI have put you down for a $(echo $SERVICE | sed -r 's/^ *| *$//g') at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."
  elif [[ $1 == 3 ]]
  then
    #style
    SERVICE=$($PSQL "SELECT name FROM services WHERE service_id='$1';")
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    #check if customer exists
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE';")
    #remove spaces
    CUSTOMER_NAME=$(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')
    if [[ -z $CUSTOMER_NAME ]]
    then
      echo -e "\nWe don't have you in our records. What's your name?"
      read CUSTOMER_NAME
      #add customer
      CUSTOMER_INSERT_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME');")
    fi
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE' AND name='$CUSTOMER_NAME';")
    echo -e "\nWhat time would you like your style, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')?"
    read SERVICE_TIME
    APPT_INSERT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")
    echo -e "\nI have put you down for a $(echo $SERVICE | sed -r 's/^ *| *$//g') at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."
  else
    #perm
    SERVICE=$($PSQL "SELECT name FROM services WHERE service_id='$1';")
    echo "$SERVICE"
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    #check if customer exists
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE';")
    #remove spaces
    CUSTOMER_NAME=$(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')
    if [[ -z $CUSTOMER_NAME ]]
    then
      echo -e "\nWe don't have you in our records. What's your name?"
      read CUSTOMER_NAME
      #add customer
      CUSTOMER_INSERT_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME');")
    fi
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE' AND name='$CUSTOMER_NAME';")
    echo -e "\nWhat time would you like your perm, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')?"
    read SERVICE_TIME
    APPT_INSERT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")
    echo -e "\nI have put you down for a $(echo $SERVICE | sed -r 's/^ *| *$//g') at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."
  fi
}

SALON_MENU