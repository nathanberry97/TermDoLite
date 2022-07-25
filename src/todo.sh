#!/bin/bash

TODO_PATH=$(find ~/.scripts/ -name todo.csv)

new_task() {
  index=($(tail -n 1 $TODO_PATH | awk -F , '{print $1}'))
  let "index=index+1"
  echo $index,$OPTARG,todo >> $TODO_PATH
}

mv_inprogress() {
  sed -i "" "$OPTARG s/todo/inprogress/" $TODO_PATH
  inprogress
}

mv_completed() {
  sed -i "" "$OPTARG s/inprogress/done/" $TODO_PATH
  completed
}

inprogress() {
  echo
  echo " inprogress "
  echo  ------------
  awk -F , ' $3 ~ /inprogress/ {print $1 ") " $2}' $TODO_PATH
  exit 0
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
  echo " backlog "
  echo  ---------
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
  echo "  -n        create new task and adds to the backlog"
  echo "  -m        moves todo to inprogress. Requires index"
  echo "  -d        moves inprogress to done. Requires index"
  echo "  -b        lists all tasks in backlog"
  echo "  -i        lists all tasks in inprogress"
  echo "  -c        lists all tasks in done"
  echo "  -h        help menu"
  exit 0
}

invalid_option() {
  echo "Invalid option: -$OPTARG"
  exit 1
}

argument_needed() {
  echo "Option -$OPTARG requires an argument."
  exit 1
}

while getopts ":n:m:d:b?c?i?h?" opt; do
  case $opt in
    m)
      mv_inprogress;;
    d)
      mv_completed;;
    n)
      new_task;;
    b)
      todo;;
    c)
      completed;;
    i)
      inprogress;;
    h)
      menu_help;;
    \?)
      invalid_option;;
    :)
      argument_needed;;
  esac
done

echo
echo ' backlog / inprogress'
echo  ----------------------
awk -F , '$3 ~ /todo/ || $3 ~ /inprogress/  {print $1 ") " $2} ' $TODO_PATH
