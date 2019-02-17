//web3
let account;
window.addEventListener('load', async () => {
	if (window.ethereum) {
    	window.web3 = new Web3(ethereum);
    	try {
    		await ethereum.enable();
    		account = web3.eth.accounts[0];
    		document.getElementById("account").innerHTML = account;
    	} catch (error) {
    		console.log(error);
    	}
  	} else if (window.web3) {
    	window.web3 = new Web3(web3.currentProvider);
    	account = web3.eth.accounts[0];
    	document.getElementById("account").innerHTML = account;
  	} else {
    	console.log('no web3!');
  	}
});

//contract
const contractAbi = [{"constant":true,"inputs":[],"name":"BANCOR","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_ethAmount","type":"uint256"}],"name":"getEth2DaiBuyPrice","outputs":[{"name":"_rate","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"latestBlock","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_ethAmount","type":"uint256"}],"name":"getUniswapBuyPrice","outputs":[{"name":"_rate","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_ethAmount","type":"uint256"}],"name":"getBancorBuyPrice","outputs":[{"name":"_rate","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"KYBERETH","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_ethAmount","type":"uint256"}],"name":"getBancorSellPrice","outputs":[{"name":"_rate","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_ethAmount","type":"uint256"}],"name":"getKyberSellPrice","outputs":[{"name":"_reserveAddress","type":"address"},{"name":"_rate","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"getEthBalance","outputs":[{"name":"_ethAmount","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"BNT","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"KYBER","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"BANCORDAI","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"getDaiBalance","outputs":[{"name":"_tokenAmount","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"FIVE_PERCENT","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"BANCORETH","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"latestRate","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_ethAmount","type":"uint256"}],"name":"getUniswapSellPrice","outputs":[{"name":"_rate","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"getLatestSavedRate","outputs":[{"name":"_rate","type":"uint256"},{"name":"_block","type":"uint256"},{"name":"_costToMoveFivePercent","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"WETH","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"KYBER_OASIS_RESERVE","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"KYBER_UNISWAP_RESERVE","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"UNISWAP","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"latestCostToMovePrice","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"ETH2DAI","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"DAI","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"getLatestRate","outputs":[{"name":"_rate","type":"uint256"},{"name":"_block","type":"uint256"},{"name":"_costToMoveFivePercent","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"ONE_ETH","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_ethAmount","type":"uint256"}],"name":"getEth2DaiSellPrice","outputs":[{"name":"_rate","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_ethAmount","type":"uint256"}],"name":"getKyberBuyPrice","outputs":[{"name":"_reserveAddress","type":"address"},{"name":"_rate","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"payable":false,"stateMutability":"nonpayable","type":"fallback"}];
const contractAbiView = [{"constant":true,"inputs":[],"name":"BANCOR","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_ethAmount","type":"uint256"}],"name":"getEth2DaiBuyPrice","outputs":[{"name":"_rate","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"updateCurrentRate","outputs":[{"name":"_rate","type":"uint256"},{"name":"_costToMoveFivePercent","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_ethAmount","type":"uint256"}],"name":"getUniswapBuyPrice","outputs":[{"name":"_rate","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_ethAmount","type":"uint256"}],"name":"getBancorBuyPrice","outputs":[{"name":"_rate","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"KYBERETH","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_ethAmount","type":"uint256"}],"name":"getBancorSellPrice","outputs":[{"name":"_rate","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"getEthBalance","outputs":[{"name":"_ethAmount","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"BNT","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"KYBER","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"BANCORDAI","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"getDaiBalance","outputs":[{"name":"_tokenAmount","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"FIVE_PERCENT","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"BANCORETH","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_ethAmount","type":"uint256"}],"name":"getUniswapSellPrice","outputs":[{"name":"_rate","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"WETH","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"KYBER_OASIS_RESERVE","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"KYBER_UNISWAP_RESERVE","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"UNISWAP","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"ETH2DAI","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"DAI","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"ONE_ETH","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_ethAmount","type":"uint256"}],"name":"getEth2DaiSellPrice","outputs":[{"name":"_rate","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"payable":false,"stateMutability":"nonpayable","type":"fallback"}];
const contractAddress = "0x04ac1eb4bdcce9cf16b3e44d9cf3ece2d4911906";
const contractInstance = web3.eth.contract(contractAbi).at(contractAddress);
const contractAddressView = "0xde1f1ea07370b0ee063c2306c240b1e579c4ff34";
const contractInstanceView = web3.eth.contract(contractAbiView).at(contractAddressView);

//read functions
setInterval(function() {
	contractInstance.getLatestSavedRate(function(err, res) {
		if (err) {
			console.log(err);
			return;   
		} else {
			document.getElementById("block").innerHTML = res[1];
		}
	});

	contractInstanceView.updateCurrentRate(function(err, res) {
		if (err) {
			console.log(err);
			return;   
		} else {
			document.getElementById("price").innerHTML = (web3.fromWei(res[0], "ether").toFixed(2) + " ETH");
			document.getElementById("value").innerHTML = (web3.fromWei(res[1], "ether").toFixed(2) + " ETH");
		}
	});

	web3.eth.getBlockNumber(function(err, res){ 
	  if (err) {
			console.log(err);
			return;   
		} else {
			document.getElementById("blockNum").innerHTML = res;
		}
	});
	
}, 500);

//update contract price
function sendUpdate() {
	console.log("price update sent")
	contractInstance.getLatestRate({from: web3.eth.accounts[0]}, function(err, txHash) {
	    if (err) {
	    	console.log(err);
	    	return;
	    } else {
			console.log(txHash);
		}
  	});
}

