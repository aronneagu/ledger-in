#!/bin/bash
# arguments: transaction_description account sum [commodity] [account sum [commodity]]
# check if LEDGER_FILE exists
# get date and transaction description and add to ledger file
# separate command line arguments based on tokens into triple of account_name-sum-commodity
# account name can be partial match, use grep case insensitive. if the account name does not exist promt to create it, suggest default name the name give as arument, but the user can add a new name. if there are multiple matching accounts, list all matches and ask user to choose which one to use
# last account can have missing the commodity, because ledger allows it
# commodity is just another name for currency
# allow for defining a default commodity
# tell where to put the commodity, prefix or suffix of the sum
# make it as simple as possible and not a tad more complicated
# might be complicated adding currency. just use a default currency defined in this script
#currency="$"
#currency=" EUR"
#might solve spacing issue of currency before or after sum

USAGE="usage"

# check if LEDGER_FILE exists
if [ ! -f "$LEDGER_FILE" ];then
    echo "Ledger file not found"
fi

# if number of arguments is 0 then print usage
if [ "$#" -le "2" ]; then
    echo $USAGE
    exit 1
fi

current_date=$(date +%Y-%m-%d)
description=$1
shift
echo "$current_date $description" >> "$LEDGER_FILE"

while (( "$#" ));do
ammount=$2
# get the account name, based on $1
account_number=$(grep -i $1 "$LEDGER_FILE"|awk '{print$1}'|sort|uniq|wc -l)
if [ "$account_number" == "0" ];then
    echo "Account does not exist. Do you want to create [$1]?:"
    read account
    if [ "$account" == "" ];then
        account=$1
    fi
elif [ "$account_number" == "1" ];then
    account=$1
elif [ "$account_number" -gt "1" ];then
    echo "Select account you want to use:"
    declare -a accounts=($(grep -i $1 "$LEDGER_FILE"|awk '{print$1}'|sort|uniq))
    for i in $(seq 0 $(( ${#accounts[@]}-1 )) );do
        echo "[$i] ${accounts[i]}"
    done
    read -p "Selection:" selection
    account=${accounts[$selection]}
    echo $account
fi
echo -e "  $account \t$ammount" >> "$LEDGER_FILE"
if [ "$#" -ge "2" ];then
    shift 2
elif [ "$#" == "1" ];then
    shift
fi
done

# for style, add a new line between transactions
echo >> "$LEDGER_FILE"
