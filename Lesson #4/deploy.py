import os
import json
from web3 import Web3
from pathlib import Path
from dotenv import load_dotenv
from solcx import compile_standard, install_solc

# path = "../Lesson #1/simpleStorage.sol" does not work idk, parent is taken from root folder
# path = "Lesson #1/simpleStorage.sol" works though
path = Path(__file__).parent / "../Lesson #1/simpleStorage.sol"
with path.open() as f:
    simple_storage_file = f.read()

# compile the solidity file
install_solc("0.6.0")
compiledSol = compile_standard(
    {
        "language": "Solidity",
        "sources": {str(path): {"content": simple_storage_file}},
        "settings": {
            "outputSelection": {
                "*": {"*": ["abi", "metadata", "evm.bytecode", "evm.sourceMap"]}
            }
        },
    },
    solc_version="0.6.0",
)

# save the compiled code in json format
# with open("./Lesson #4/compiled_code.json", "w") as f:
#     json.dump(compiledSol, f)

# get bytecode
bytecode = compiledSol["contracts"][str(path)]["SimpleStorage"]["evm"]["bytecode"][
    "object"
]

# get abi
abi = compiledSol["contracts"][str(path)]["SimpleStorage"]["abi"]

# connecting to blockchain on Ganache
w3 = Web3(Web3.HTTPProvider("http://127.0.0.1:8545"))
chainId = 1337
myAddress = "0x90F8bf6A479f320ead074411a4B0e7944Ea8c9C1"

# never hardcode your private key like this, use environment variables
# append 0x to the beginning of your private key
load_dotenv()
private_key = os.getenv("PRIVATE_KEY")

# create the contract
contract = w3.eth.contract(abi=abi, bytecode=bytecode)

# get the nonce, which is the latest transaction by our account
nonce = w3.eth.getTransactionCount(myAddress)

# build a transaction
transaction = contract.constructor().buildTransaction(
    {"gasPrice": w3.eth.gas_price, "chainId": chainId, "from": myAddress, "nonce": nonce}
)

# sign the transaction
signedTxn = w3.eth.account.sign_transaction(transaction, private_key=private_key)

print("Deploying Contract...")

# send the transaction
txnHash = w3.eth.send_raw_transaction(signedTxn.rawTransaction)
txnReceipt = w3.eth.wait_for_transaction_receipt(txnHash)

print(txnReceipt)
print("Deployed!")

# to interact with the contract, get the contract address and abi
simpleStorage = w3.eth.contract(address=txnReceipt.contractAddress, abi=abi)

# two types of interactions
# call -> read data from the blockchain
# transact -> change state of the blockchain

# print the intial value
print("Initial value:", simpleStorage.functions.retrieve().call())
print("Updating...")

# repeat the same process of signing and sending contract for a transaction
sTransaction = simpleStorage.functions.store(15).buildTransaction(
    {"gasPrice": w3.eth.gas_price, "chainId": chainId, "from": myAddress, "nonce": nonce + 1}
)
signedSTxn = w3.eth.account.sign_transaction(sTransaction, private_key=private_key)
txnHash = w3.eth.send_raw_transaction(signedSTxn.rawTransaction)
txnReceipt = w3.eth.wait_for_transaction_receipt(txnHash)

# call the contract again
print("New Value:", simpleStorage.functions.retrieve().call())
print("Updated!")

