const Web3 = require('web3');
let rpc_yrl = "http://193.112.195.120:8545";
let tx_hash = "0xc04aff794079397ef08d41728ccaeee3762279b0ed11c5a8f5bc9cb59e0f4017";

let web3;

let InitWeb3 = async function() {
    if (typeof web3 !== 'undefined') {
        web3 = new Web3(web3.currentProvider);
    } else {
        web3 = new Web3(new Web3.providers.HttpProvider(rpc_yrl));
    }
}

let GetTxDataByTxHash = async function(hash) {
    try {
        web3.eth.getTransaction(hash, function(error, ret) {
            if (error) {
                console.log(error.message);
            } else {
                console.log(JSON.stringify(ret));
            }
        });
    } catch (error) {
        console.log(error.stack);
    }
}


InitWeb3();
GetTxDataByTxHash(tx_hash);



