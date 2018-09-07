const fs = require("fs");
const solc = require('solc');
const Web3 = require('web3');
const rpc_yrl = "http://193.112.195.120:8545";
const contract_path = "../common/contracts/SolitaireUpgrate.sol";

let web3;
let InitWeb3 = async function() {
    if (typeof web3 !== 'undefined') {
        web3 = new Web3(web3.currentProvider);
    } else {
        web3 = new Web3(new Web3.providers.HttpProvider(rpc_yrl));
    }
}
InitWeb3();

let source = fs.readFileSync(contract_path, 'utf8');
let compiledContract = solc.compile(source, 1);

let abi = compiledContract.contracts[':SolitaireUpgrate'].interface;
let bytecode = compiledContract.contracts[':SolitaireUpgrate'].bytecode;

web3.eth.estimateGas({data: "0x" + bytecode}, (err, ret) => {
    if (err) {
        console.log(err.stack);
    } else {
        console.log(JSON.stringify(ret));
    }
});