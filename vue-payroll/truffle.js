var HDWalletProvider = require("truffle-hdwallet-provider");
var mnemonic = "cruise aware clap naive dignity paper code virtual swap time gaze pond";
module.exports = {
    networks: {
        development: {
          host: "localhost",
          port: 8545,
          network_id: "*" // Match any network id
        },
        ropsten: {
          provider: new HDWalletProvider(mnemonic, "https://ropsten.infura.io/e0ymtft1rrwAaFHswWmW"),
          gas: 2100000,
          // 这里的 e0ymtft1rrwAaFHswWmW  换成你自己在 infura.io上获取的key
          network_id: 3
        }
    }
};
