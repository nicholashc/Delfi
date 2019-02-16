const Web3 = require('web3');
const rlp = require('rlp');
const keccak = require('keccak');	
const secp256k1 = require('secp256k1');
const randomBytes = require('randombytes');

web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

const privateToAddress = (privateKey) => {
    const pub = secp256k1.publicKeyCreate(privateKey, false).slice(1);
    return keccak('keccak256').update(pub).digest().slice(-20).toString('hex');
};

const getRandomWallet = () => {
    const randbytes = randomBytes(32);
    return {
        address: ("0x" + privateToAddress(randbytes).toString('hex')),
        privKey: randbytes.toString('hex')
    };
};

let nonce = 0;
let nonceMax = 10;
let iterations = 10000000;
let keyPair = {}
let sender;
let privateKey;
let stop = false;

for (let j = 0; j < iterations; j++) {

	for (let i = 1; i < nonceMax; i++) {

		nonce = web3.utils.toHex(i);
		keyPair = getRandomWallet();
		sender = keyPair.address;
		privateKey = keyPair.privKey;

		let input_arr = [sender, nonce];
		let rlp_encoded = rlp.encode(input_arr);
		let contract_address_long = keccak('keccak256').update(rlp_encoded).digest('hex');
		let contract_address = contract_address_long.substring(24); 
		
		console.log("0x" + contract_address);

		if (contract_address.slice(0,6) == "04ac1e") {
			console.log(
				"address:", sender, 
				"priavte key: 0x" + privateKey, 
				"nonce:", Number(nonce),
				"vanity: 0x" + contract_address
			);
			stop = true
			break
		}
	}

	if (stop === true) {
		break
	}
}