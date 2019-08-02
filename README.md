# Delfi

***Aug 1, 2019**: we've neglected Delfi over the last few months, but are happy to see it's still cranking out price data on mainnet. The demand for on-chain data has continued to explode since the project started. Please see the section beginning from ["Roadmap"](#Roadmap) for the latest thoughts/plans and a renewed commitment to development. The other content is from the original ETH Denver 2019 hackathon.* 

### About
Delfi is a simple on-chain price oracle you can reason about. It provides a liquidity-weighted index of ETH/DAI prices from decentralized exchanges. The price is backed up by the ETH amount required to move the rate more than 5%. This provides a quantifiable threshold of economic activity the price can safely support. The first version provides a dynamic weighted index of the ETH/DAI pair across the three on-chain decentralized exchanges with the most ETH/DAI volume and liquidity: Uniswap, Eth2Dai, and Bancor.

Delfi won the Open Track Finalist award and Most Innovative award at EthDenver 2019!

Visit our [aggressively unstyled web 1.0 site](https://delfi.surge.sh/) for web 3.0 data. Find the contracts on the Ethereum mainnet at [0x04acle...](https://etherscan.io/address/0x04ac1eb4bdcce9cf16b3e44d9cf3ece2d4911906#code) and [0xde1f1...](https://etherscan.io/address/0xde1f1ea07370b0ee063c2306c240b1e579c4ff34#code).

To interact with Delfi on the Ethereum mainnet, please include one of the following interfaces in your contract. They offer slightly different functionality for different use cases. The first contract at 0x04acle... offers a slightly more expensive method that returns up-to-the-block price information and saves this rate in state. It also offers a very inexpensive method that returns the most recent saved rate information. This contract is best for uses cases that may only need periodic price updates. The second contract at 0xde1f1... only offers a view method, which is most appropriate for web3 queries or slightly cheaper on-chain calls that require up-to-the-block price information at the time of execution.

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
	 * comparatively cheap, but may be outdated
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

---

### Roadmap

The first version of Delfi was a quick and dirty proof of concept built at ETH Denver. It was focused on providing on-chain ETH/DAI spot prices at the time of execution. The goals and scope were, and still are: 

1. Provide current price data and quantify the economic threshold beyond which the price is no longer trustworthy 
2. The project should have no ongoing costs other than time and ask for no payment other than gas
3. The code should be unstoppable, unpausable, and without privileged permissions

Even within these narrow bounds, Delfi has room to grow. Some planned near(-to-medium)-term research and development include:

#### Review of the current Ethereum ecosystem

- 	Which decentralized exchanges are most active and most liquid?
- 	What is the state of the live or near-release oracle services?
- 	How do the top DeFi projects manage their price feeds? 
- 	Have there been any important research developments or new projects related to "the oracle problem"? 
- 	Would additional stablecoin(s) improve Delfi's price data?
- 	How can we integrated data from relayer protocols?

#### Full Contract Refactor

- 	Rework the math/precision in the weighted price calculation
- 	Improving the security of data sampling via more sources and better handling of outliers
- 	Rethink incentives for users to update state
- 	Optimize gas costs
- 	Offer access to raw inputs so users can construct their own weighted formulas 
- 	Write unit tests
- 	Audit

#### Closer Look at Dex Security 
- 	Uniswap has at least two classes of active bots (and many instances of each)
	- Atomic arbitrageurs: large trades into uniswap create a temporary price move that is quickly bought/sold for guaranteed profit on another exchange, all in one tx
	- 	Sandwich frontrunners: many uniswap traders use the default 2% slippage threshold set on the UI. Their buy is often frontrun, then the attacker immediately sells for a small profit after the honest user's tx confirms. The user receives fewer tokens than they expected
- 	Bancor has similar issues, despite their global gas price restriction
- 	Synthetix (while not directly connected) recently had a serious issue with the integrity of one of their oracles
- 	How can Delfi guard against these situations affecting price data?

#### A Public Good Should Public 
- 	Share ideas with relevant people/teams/contacts via twitter/telegram/discord/etc
- 	Contribute to other projects working on oracles and related areas
- 	Submit as a resource to directories like EthHub and BUILD Guide
- 	Redo the website with a framework from this century and add support for more wallet types 

---

### Ecosystem Research 

*(in-progress)*

#### Recent Work on Oracles/Prices/Trading

###### On-Chain Activity
Phil Daian et al's [Flash Boys 2.0](https://arxiv.org/abs/1904.05234) paper unpacks the competitive tactics and escalating arms race between frontrunners and other actors looking to exploit on-chain trading.

###### Economic Guarantees

UMA's recent [UMA Data Verification Model](https://github.com/UMAprotocol/whitepaper/blob/master/UMA-DVM-oracle-whitepaper.pdf) paper provides a strong framework for the formal and economic guarantees oracle data. "Cost of Corruption," if slightly misinterpreted, is a nice term for Delfi's concept of a value threshold beyond which data becomes untrustworthy.

###### Compound's New Oracle?

Compound Protocol seems to have an active repo in development for an [Open Oracle](https://github.com/compound-finance/open-oracle). (DelFiPrice.sol 😂...great name!). Documentation is limited at this stage but it seems like a medianized feed that allows users to submit new prices via signature. Compound has long stated they would decrease their control over the price feeds as the project matures. 

###### Incentivizing Oracle Updates

[Polaris](https://github.com/marbleprotocol/polaris) takes backdated checkpoints from Uniswap ERC20 prices. They have an interesting subscription payment model that provides funding to incentivize "pokes" which update the contract state. This seemed quite active on mainnet for awhile but has since become dormant.

###### Proof of Work as Data Source

[Tellor](https://github.com/DecentralizedDerivatives/MineableOracle) is a "proof of work" oracle. It proposes an incentive model where users submit queries and miners return their requests as part of a new block. Miners providing valid data are rewarded with tokens.

#### DeFi Price Feeds 

###### MakerDao

[MakerDao's price feed](https://developer.makerdao.com/feeds/) is likely the most important source of off chain data on the network. Not only is it central to their protocol, but many other applications rely on the integrity of this data. The oracle is composed of multiple independent operators who submit price information under certain conditions. This is then "medianized" to parse outliers. The integrity of this system falls to MKR governance mechanisms. It seems like MCD will have a similar approach, though with a unique oracle for each asset and some additional security measures.

###### Compound

Compound sets their prices through an [oracle contract](https://etherscan.io/address/0x02557a5e05defeffd4cae6d83ea3d173b272c904) they control. It's updated as frequently as needed by calls from a permissioned address. Compound v1 used Maker's price feed for DAI. v2 sources prices from Bittrex, Poloniex, Binance, and Coinbase, with averaging and limits on large sudden price movements.

###### Synthetix

Synthetix currently relies on a [central oracle contract](https://etherscan.io/address/0x70C629875daDBE702489a5E1E3bAaE60e38924fa), which only a permissioned addresses can update. Notably, they recently had a serious [security issue](https://blog.synthetix.io/response-to-oracle-incident/) when a failed api in one of their oracles caused a 1000x price on one token pair. This error was quickly exploited by arb bots (though funds were later returned). The internal stability of sUSD and other synthetic tokens is supposed to be maintained by user incentives, though it often trades well below its peg on outside markets.

###### dYdX

v2 of dYdX pulls DAI data into their   [oracle contract](https://etherscan.io/address/0x787F552BDC17332c98aA360748884513e3cB401a#code) from Eth2Dai, Uniswap, and Maker's price feed. ETH price data comes directly from Maker's feed.

###### Dharma

Dharma Lever underwrites loans, sets rates, and determines risk as trusted oracle. 

###### Set

The current Set system uses a [managed oracle](https://www.setprotocol.com/pdf/managed_sets_whitepaper.pdf) contract to determine when sets are rebalanced. Future explorations suggest a move towards a [trust-minimized](https://medium.com/set-protocol/product-teaser-trustless-rebalancing-5aa77ab404b6) system.

###### Nuo
[Nuo](https://help.nuo.network/article/how-does-nuo's-price-feed-work/) uses a volume weighted average from centralized exchanges but sources liquidity from Uniswap and Kyber. Their price feed is supposed to be fenced within a range but there have been price crashes leading to unexpected liquidations.

###### bZx
Fulcrum uses Kyber's price feed, which in turn is composed of independently managed liquidity reserves who set their own rates. This is fairly robust with high volume tokens like DAI or MKR. However, illiquid tokens may only have a single reserve setting prices.

#### Active/In Development Oracle Projects

###### Oraclaize (now Provable)
###### Chainlink
###### UMA
###### Zap
###### Rhombus
###### Gardener
###### Witnet
###### Truebit
###### Town Crier
###### Augur (prediction market)
###### Helena (prediction market)

#### Decentralized Exchanges

Snapshot of some of the relevant dexes as of Aug 2019. There is a wide range of "decentralization" represented in this list.

###### Liquidity Pools
* Uniswap
* Kyber
* Bancor

###### On-Chain Order Books
* Eth2Dai
* Etherdelta/Forkdelta 
* IDEX

###### Relayers/Indexers
* RadarRelay
* Airswap
* TokenIon
* DDEX

###### Auctions
* DutchX

#### Stablecoin Ecosystem

###### Stablecoins

* DAI
* USDC
* tUSD
* GUSD
* USD₮ (Tether ERC-20)
* PAX

###### Derivatives

* cDAI (Compound)
* cUSDC (Compound)
* sUSD (Synthetix)
* iDAI (bZx)
* iUSDC (bZx)
