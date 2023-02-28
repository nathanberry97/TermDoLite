#!/bin/bash

TODO_PATH=$(find ./ -name todo.csv)

reset() {
  echo 0,task,status > ${TODO_PATH}
  exit 0
}

new_task() {
  INDEX=($(tail -n 1 $TODO_PATH | awk -F , '{print $1}'))
  let "INDEX++"
  echo $INDEX,$OPTARG,todo >> $TODO_PATH
}

mv_completed() {
  let "OPTARG++"
  sed -i "${OPTARG}s/todo/done/" $TODO_PATH
  completed
}

completed() {
  echo
  echo " completed "
  echo  -----------
  awk -F , ' $3 ~ /done/ {print $1 ") " $2}' $TODO_PATH
  exit 0
}

todo() {
  echo
  echo " inprogress "
  echo  ------------
  awk -F , ' $3 ~ /todo/ {print $1 ") " $2}' $TODO_PATH
  exit 0
}

menu_help() {
  echo -e "TermDoLite\n"
  echo -e "Usage: ag [argument] string"
  echo -e "Usage: ag [argument] int"
  echo -e "   or: ag [argument]"
  echo -e "   or: ag [no flag returns all tasks]\n"
  echo "Arguments:"
  echo "  -n        create new task"
  echo "  -m        moves todo to completed. Requires index"
  echo "  -l        lists all tasks in inprogress"
  echo "  -c        lists all tasks in completed"
  echo "  -r        removes all items form todo list"
  echo "  -h        help menu"
  exit 0
}

invalid_option() {
  echo "Invalid option: -${OPTARG}"
  exit 1
}

argument_needed() {
  echo "Option -${OPTARG} requires an argument."
  exit 1
}

while getopts ":m:n:l?c?r?h?" opt; do
  case $opt in
    m)
      mv_completed;;
    n)
      new_task;;
    l)
      todo;;
    c)
      completed;;
    r)
      reset;;
    h)
      menu_help;;
    \?)
      invalid_option;;
    :)
      argument_needed;;
  esac
done

todo
