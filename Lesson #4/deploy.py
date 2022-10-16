import json
from pathlib import Path
from solcx import compile_standard, install_solc

# path = "../Lesson #1/simpleStorage.sol" does not work idk, parent is taken from root folder
# path = "Lesson #1/simpleStorage.sol" works though
path = Path(__file__).parent / "../Lesson #1/simpleStorage.sol"
with path.open() as f:
    simple_storage_file = f.read()

# compile the solidity file
install_solc("0.6.0")
compiled_sol = compile_standard(
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
with open("./Lesson #4/compiled_code.json", "w") as f:
    json.dump(compiled_sol, f)

# get bytecode
bytecode = compiled_sol["contracts"][str(path)]["SimpleStorage"]["evm"]["bytecode"]["object"]
print(bytecode)

# get abi
abi = compiled_sol["contracts"][str(path)]["SimpleStorage"]["abi"]

