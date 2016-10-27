# ledger-in

## Synopsis
Ledger-in is an addon for the accounting software ledger. Ledger-in allows fast entry of transaction in the ledger file

## Motivation

There is ledger-add that performs a similar task of entry data into the ledger file, but that requires entering the exact
names of the accounts. On the other hand, ledger-in can take as input partial names of the accounts and it's smart enough 
to determine which account to use, and if more accounts match, then it prompts the use to select the one he intended to use.
Additionally, ledger-in writes in the same file, unlike ledger-add which writes the transaction in a new file.

## Usage

`ledger-in [-f] <description> <account-1> <ammount-1> <account-2> <ammount-2> [...]`

The ledger file to use is read either from the environment variable LEDGER_FILE or passed as an argument with option -f.
The <description> is a description of the transaction. If you want to pass a long description that contains spaces you need to 
surround it with double quotes. Afterwards the program takes an unlimited number of pairs of `<account> <ammount>`. The last
`<ammount>` is optional. As an example, considering LEDGER_FILE environment variable is set and points to a ledger file:

`ledger-in "ATM Withdrawal" Asets:Checking -20 Assets:Cash 20`

The ammount of the last account can be ommited, so the previous command is equivalent with:

`ledger-in "ATM Withdrawal" Asets:Checking -20 Assets:Cash`

Ledger-in is smart enough to determine the account name from a partial match. If Assets:Checking and Assets:Cash already exist
in the ledger file, then the following command is similar with the previous one

`ledger-in "ATM Withdrawal" checking -20 cash`

If `cash` does not match any existing account, then ledger-in will prompt to enter a name for it

If `checking` matches multiple accounts, for example Assets:Visa:Checking and Assets:Mastercard:Checking, then ledger-in will
prompt you to choose which account to use

