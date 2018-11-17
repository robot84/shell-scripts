#!/bin/bash

main(){
  
  echoerr $ROUNDS
  
  create_progress_bar $ROUNDS
  main_loop
}


main_loop(){
  while true
  do
    do_all
    update_progress_bar
  done
}

do_all() {
}

echoerr() { echo "$@" 1>&2; }

create_progress_bar(){
  PROGRESS_BAR_COUNTER=0
  let "ONE_PERCENT_IS = $ROUNDS / 100"
  let "TWO_PERCENTS_IS = $ONE_PERCENT_IS * 2"
  echoerr $ONE_PERCENT_IS
  echoerr $TWO_PERCENTS_IS
  
  echoerr -ne "|#"
  
  for VAR in {1..22}
  do
    echoerr -ne " "
  done
  
  echoerr -ne "."
  
  for VAR in {1..23}
  do
    echoerr -ne " "
  done
  
  echoerr -ne "|\r"
}

update_progress_bar(){
  if [ $PROGRESS_BAR_COUNTER -gt $TWO_PERCENTS_IS ];
  then
    echoerr -ne "#"
    PROGRESS_BAR_COUNTER=0
  else
    let "PROGRESS_BAR_COUNTER = $PROGRESS_BAR_COUNTER + 1"
  fi
}




main "$@"
