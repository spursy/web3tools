const fs = require("fs");
const solc = require('solc');
const Web3 = require('web3');
const rpc_yrl = "http://193.112.195.120:8545";
const ABI_path = "../common/contracts/SolitaireUpgrate.json";
const contract_address = "0xb2692c024FB69e019F66986Eb5b030d679350e78";


let web3;
let InitWeb3 = async function() {
    if (typeof web3 !== 'undefined') {
        web3 = new Web3(web3.currentProvider);
    } else {
        web3 = new Web3(new Web3.providers.HttpProvider(rpc_yrl));
    }
}
InitWeb3();

let source = fs.readFileSync(ABI_path, 'utf8');
// creation of contract object
var MyContract = web3.eth.contract(source);
// initiate contract for an address
var myContractInstance = MyContract.at(contract_address);
// call constant function
var result = myContractInstance.deposit({ value: web3.toWei(0.1, "ether")});
console.log(result) // '0x25434534534'