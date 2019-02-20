# Delfi

### About
Delfi is a simple onchain price oracle you can reason about. It provides a liquidity-weighted index of ETH/DAI prices from decentralized exchanges. The price is backed up by the ETH amount required to move the rate more than 5%. This provides a quantifiable threshold of economic activity the price can safely support. The first version provides a dynamic weighted index of the ETH/DAI pair accross the three onchain dentralized exchanges with the most ETH/DAI volume and liquidity: Uniswap, Eth2Dai, and Bancor.

Delfi won the Open Track Finalist award and Most Innovative award at EthDenver 2019. 

Visit out [aggressivly unstyled web 1.0 site](https://delfi.surge.sh/) for web 3.0 data. Find the contracts on the Ethereum mainnet at [0x04acle...](https://etherscan.io/address/0x04ac1eb4bdcce9cf16b3e44d9cf3ece2d4911906#code) and [0xde1f1...](https://etherscan.io/address/0xde1f1ea07370b0ee063c2306c240b1e579c4ff34#code).

To interact with Delfi on the Ethereum mainnet, please include one of the following interfaces in your contract. They offer slightly different functionality for different use cases. The first contract at 0x04acle... offers a slightly more expensive method that returns up-to-the-block price information and saves this rate in state. It also offers a very inexpensive method that returns the most recent saved rate information. This contract is best for uses cases that may only need periodic price updates. The second contract only offers a view method, which is most appropriate for web3 queries.

### Interfaces

```javascript
pragma solidity ^0.5.4;

/**
 * contract at 0x04ac1eb4bdcce9cf16b3e44d9cf3ece2d4911906
 */
contract DelfiInterface {
	/**
	 * get up-to-the-block ETH/DAI rate
	 * comparatively expensive
	 * saves rate information in state
	 * approximate gas cost: 250,000
	 * @returns _rate ETH/DAI price in wei
	 * @returns _block block number at time of execution
	 * @returns _costToMoveFivePercent value required to shift the price 5% in wei
	 */
	function getLatestSavedRate() view external returns(uint256 _rate, uint256 _block, uint256 _costToMoveFivePercent) {}
	/**
	 * get most recent saved ETH/DAI rate
	 * compartively cheap, but may be outdated
	 * reads rate information from state
	 * approximate gas cost: 30,000
	 * @returns _rate last saved ETH/DAI price in wei
	 * @returns _block block number at time of last save
	 * @returns _costToMoveFivePercent last saved value required to shift the price 5% in wei
	 */
	function getLatestRate() external returns(uint256 _rate, uint256 _block, uint256 _costToMoveFivePercent) {}
}

/**
 * contract at 0xde1f1ea07370b0ee063c2306c240b1e579c4ff34
 */
contract DelfiViewInterace {
	/**
	 * get up-to-the-block ETH/DAI rate
	 * view method; nothing saved in state
	 * approximate gas cost: 235,000
	 * @returns _rate ETH/DAI price in wei
	 * @returns _costToMoveFivePercent value required to shift the price 5% in wei
	 */
	function updateCurrentRate() view external returns(uint256 _rate, uint256 _costToMoveFivePercent) {}
}
```
### To Do
We plan to continue developing Delfi as a public utility. Contributions and feedback are welcome. Some potential improvements may include:
* refinement of weighted price forumla
* gas cost optimization
* generic support for other decentralized exchanges
* generalizing the contracts to support any ERC-20 token pair
* redesigned website
