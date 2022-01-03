prompt(){
  # prompt user
  printf "\n\n\n"
  echo -n "$1"
}

get_response(){
  # get user input
  local response
  read response

  # determine action
  case $response in
    $2)
      # execute function

      $1
      ;;

    *)
      # do nothing
      :
      ;;
  esac

  # optional return
  if $3; then
    echo "$response"
  fi
}
