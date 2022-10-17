import json
from web3 import Web3
from pathlib import Path
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
w3 = Web3(Web3.HTTPProvider("http://127.0.0.1:7545"))
chainId = 1337
myAddress = "0x82920917C78717531555F57f5398e1DCf5c5DBd7"

# never hardcode your private key like this, use environment variables
# append 0x to the beginning of your private key
private_key = "0x3366759403719f627ce5187c123f83c2483b6a3e40d6f0db264c480901829c81"

# create the contract
contract = w3.eth.contract(abi=abi, bytecode=bytecode)

# get the nonce, which is the latest transaction by our account
nonce = w3.eth.getTransactionCount(myAddress)

# build a transaction
transaction = contract.constructor().buildTransaction(
    {"gasPrice": w3.eth.gas_price, "chainId": chainId, "from": myAddress, "nonce": nonce}
)
