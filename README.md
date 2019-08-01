# Delfi

***Aug 1, 2019**: we've neglected Delfi over the last few months, but are happy to see it's still cranking out price data on mainnet. The demand for on-chain data has continued to explode since the project started. Please see the section beginning from ["Roadmap"](#Roadmap) for the latest thoughts/plans and a renewed commitment to development. The other content is from the original ETH Denver 2019 hackathon.* 

### About
Delfi is a simple onchain price oracle you can reason about. It provides a liquidity-weighted index of ETH/DAI prices from decentralized exchanges. The price is backed up by the ETH amount required to move the rate more than 5%. This provides a quantifiable threshold of economic activity the price can safely support. The first version provides a dynamic weighted index of the ETH/DAI pair accross the three onchain dentralized exchanges with the most ETH/DAI volume and liquidity: Uniswap, Eth2Dai, and Bancor.

Delfi won the Open Track Finalist award and Most Innovative award at EthDenver 2019!

Visit our [aggressivly unstyled web 1.0 site](https://delfi.surge.sh/) for web 3.0 data. Find the contracts on the Ethereum mainnet at [0x04acle...](https://etherscan.io/address/0x04ac1eb4bdcce9cf16b3e44d9cf3ece2d4911906#code) and [0xde1f1...](https://etherscan.io/address/0xde1f1ea07370b0ee063c2306c240b1e579c4ff34#code).

To interact with Delfi on the Ethereum mainnet, please include one of the following interfaces in your contract. They offer slightly different functionality for different use cases. The first contract at 0x04acle... offers a slightly more expensive method that returns up-to-the-block price information and saves this rate in state. It also offers a very inexpensive method that returns the most recent saved rate information. This contract is best for uses cases that may only need periodic price updates. The second contract at 0xde1f1... only offers a view method, which is most appropriate for web3 queries or slightly cheaper onchain calls that require up-to-the-block price information at the time of execution.

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
contract DelfiViewInterface {
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
### Roadmap

The first version of Delfi was a quick and dirty proof of concept built at ETH Denver. It was focused on providing on-chain ETH/DAI spot price at the time of excution & the cost of manipulating that price by x percent. The goals and scope were, and still are: 

1) provide current-to-the-block price data, with a quantifyable value attactched to its trustworthiness 
2) the projcet should have no costs other than time and ask for no payment other than gas
3) the code should be unstoppable, unpausable, and without priveleged permissions

Even within these narrow bounds, Delfi has room to grow. Some planned near(-to-medium)-term research and development include:

* updated review of the current Ethereum ecosystem
	* which decentralized exchanges have the most liquid trading pairs and active user bases?
	* what oracle services exist/are in active development? What are their trade offs? Are they being used?
	* how do the top DeFi projects get their price information? 
	* have there been any important research developments or new approaches to "the oracle problem"? 
	* could we add additional stable coin(s) with sufficient liquidity? (probably only USDC qualifies)
	* can we integrated data from protocols like 0x with offchain order books?

* full refactoring of the Delfi contracts with a focus on:
	* refining the math/precision in the weighted price calculation
	* improving the security of the data via sampling more, and more diverse sources, as well as medianizing/dropping outliers
	* full rethinking of the game theoretic incentives for users updating state, possibly enabling historical data availability
	* gas optimization
	* offering greater customization for users to construct their own weighted forumlas 
	* writing unit tests
	* external audits, if possible

* deeper investigation into the security of the exchanges Delfi relies on
	* uniswap has at least two classes of active bots (and many instances of each)
		* atomic arbitraguers: large trades into uniswap create a temporary price move that is quickly bought/sold for guarenteed profit on another exchange, all in one tx
		* sandwich frontrunners: many uniswap traders use the default 2% slippage threshold set on the UI. Their buy is often frontrun, then the attacker immediately sells for a small profit after the honest user's tx confirms. The user receives fewer tokens than they expected
	* bancor has similar issues, despite their global gas price restriction
	* Synthetix (while not directly connected) recently had a serious issue with the integrity of one of their oracles
	* how can Delfi guard against these situations affecting price data?

* to actually be useful, Delfi needs a bit of promotion. When an improved product is ready
	* share with relevant project teams/contacts via twitter/github/telegram/discord/etc
	* contribute to code/feedback/reviews to other projects working on oracles and related areas
	* submit Delfi as a resource to places like EthHub and BUILD guide
	* the website could use a facelift with a framework from this century and support for more wallet types (as much as I love the unstyled html site)
	* the goal of any promotion would only be to spread awareness for a potentially useful utility
