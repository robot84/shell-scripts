    while [ 1 -eq 1 ] ; do
    echo "Are you sure to add $qra to database [Y/n/quit]?"
            read anwser
    case "$(echo "$anwser" | tr '[:upper:]' '[:lower:]'  )" in                                                                                       y|yes)      echo "Adding..."; break ;;
                                   n|no)      echo "Ommiting..." ; break ;;                                                                          quit)  exit ;;                                                                                                    *)        ;;
                                   esac                                                                                                                  done
