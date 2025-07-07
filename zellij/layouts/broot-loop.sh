#!/bin/bash
fail_count=0
while true; do
  broot -gIhtSD --sort-by-type --max-depth 2 --conf "$TEMPLATE/broot/broozelix.hjson;$XDG_CONFIG_HOME/broot/conf.hjson"

  if [ $? -ne 0 ]; then
    echo "Command failed. Retrying..." >&2
    ((fail_count++))
    if [ "$fail_count" -ge 5 ]; then
      read -p "You exited 5 times! Is this intentional? (y/N): " confirm
      if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo "Exiting loop." >&2
        break
      else
        fail_count=0  # reset the counter if user wants to continue
      fi
    fi
  else
    fail_count=0  # reset the counter if command succeeds
  fi
done
