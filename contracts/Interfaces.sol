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
