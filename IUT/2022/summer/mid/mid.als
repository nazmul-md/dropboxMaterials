enum AccountType {debitcard, creditcard}


abstract sig Account {
    accountNumber: Int,
    balance: Int,
    holder: AccountHolder
}

sig IndividualAccount extends Account {
    accountType: AccountType,
    creditLimit: lone Int
}

sig BusinessAccount extends Account {
    accountType: AccountType,
    creditLimit: lone Int
}

sig AccountHolder {
    name: String,
    address: String,
    dob: Date,
    identificationNumber: String
}

sig Branch {
    accounts: set Account,
    branchNumber: Int,
    branchAddress: String
}

sig Bank {
    branches: set Branch,
    bankName: String,
    bankNumber: Int
}

abstract sig Transaction {
    fromAccount: Account,
    toAccount: Account,
    amount: Int,
    date: Date
}

sig Deposit extends Transaction {

}

sig Withdrawal extends Transaction {

}

sig Transfer extends Transaction {
}

sig Transactions {
    allTransactions: set Transaction
}
sig Date {
   // day: Int,
   // month: Int,
   // year: Int
}

fact creditCardHasLimit {
    all a: IndividualAccount | a.accountType = creditcard => a.creditLimit != none
}
fact businessCardHasLimit {
    all b: BusinessAccount | b.accountType = creditcard => b.creditLimit != none
}

fact  {
all a: Account | a.balance >= 0
all a:Account| a in IndividualAccount or a in BusinessAccount
all a: Account | one a.accountNumber
}

fact {
    //Ensuring that all individual and business accounts are either debit or credit card accounts
    all i: IndividualAccount | i.accountType in AccountType
    all j: BusinessAccount | j.accountType in AccountType
}
run {} for 5
