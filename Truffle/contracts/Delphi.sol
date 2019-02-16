pragma solidity ^0.5.4;

//////////////
//INTERFACES//
//////////////

contract ERC20 {
	function balanceOf(address) external view returns(uint256) {}
}

contract Uniswap {
	function getEthToTokenInputPrice(uint256) external view returns(uint256) {}
	function getTokenToEthOutputPrice(uint256) external view returns(uint256) {}
}

contract Eth2Dai {
	function getBuyAmount(address, address, uint256) external view returns(uint256) {}
	function getPayAmount(address, address, uint256) external view returns(uint256) {}
}

contract Bancor {
	function getReturn(address, address, uint256) external view returns(uint256, uint256) {}
}

contract BancorDai {
	function getReturn(address, address, uint256) external view returns(uint256) {}
}

contract Kyber {
	function searchBestRate(address, address, uint256, bool) external view returns(address, uint256) {}
}

/////////////////
//MAIN CONTRACT//
/////////////////

contract Delphi {

	///////////////////
	//STATE VARIABLES//
	///////////////////

	uint256 public latestRate;
	uint256 public latestRateAtBlock;
	
	address constant public DAI = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;
	address constant public WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
	address constant public BNT = 0x1F573D6Fb3F13d689FF844B4cE37794d79a7FF1C;
	address constant public UNISWAP = 0x09cabec1ead1c0ba254b09efb3ee13841712be14;
	address constant public ETH2DAI = 0x39755357759cE0d7f32dC8dC45414CCa409AE24e;
	address constant public BANCOR = 0xCBc6a023eb975a1e2630223a7959988948E664f3;
	address constant public BANCORDAI = 0x587044b74004E3D5eF2D453b7F8d198d9e4cB558;
	address constant public BANCORETH = 0xc0829421C1d260BD3cB3E0F06cfE2D52db2cE315;
	address constant public KYBER = 0x9ae49c0d7f8f9ef4b864e004fe86ac8294e20950;
	address constant public KYBERETH = 0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee;

	///////////////////////////
	//CONTRACT INSTANTIATIONS//
	///////////////////////////
	
	ERC20 constant dai = ERC20(DAI);
	Uniswap constant uniswap = Uniswap(UNISWAP);
	Eth2Dai constant eth2dai = Eth2Dai(ETH2DAI);
	Bancor constant bancor = Bancor(BANCOR);
	BancorDai constant bancordai = BancorDai(BANCORDAI);
	Kyber constant kyber = Kyber(KYBER);

	///////////
	//METHODS//
	///////////
	
	/**
	 * get an ERC20 token balance
	 * @param address _token address of token contract
	 * @param address _owner address of token holder
	 * @return uint256 _tokenAmount token balance of holder in smallest unit
	 */
	function getTokenBalance(
		address _token, 
		address _owner
	) 
	public 
	view 
	returns(
		uint256 _tokenAmount
	) {
		ERC20 token = ERC2O(_token);
		return token.balanceOf(_owner);
	}

	/**
	 * get the non-token ETH balance of an address
	 * @param address _owner address to check
	 * @return uint256 balance in wei
	 */
	function getEthBalcne(
		address _owner
	)
	public
	view 
	returns(
		uint256 _ethAmount
	) {
		return _owner.balance;
	}

	/**
	 * get the buy price of DAI on uniswap
	 * @param uin256 amount of ETH being spent in wei
	 * @return uint256 returned as a rate in wei
	 */
	function getUniswapBuyPrice(
		uint256 _ethAmount
	)
	public 
	view 
	returns(
		uint256 _rate
	) {
		uint256 tokenAmount = uniswap.getEthToTokenInputPrice(_ethAmount);
		return (tokenAmount * 10**18) / _ethAmount;
	}

	/**
	 * get the sell price of DAI on uniswap
	 * @param uin256 amount of ETH being purchased in wei
	 * @return uint256 returned as a rate in wei
	 */
	function getUniswapSellPrice(
		uint256 _ethAmount
	)
	public 
	view 
	returns(
		uint256 _rate
	) {
		uint256 ethAmount = uniswap.getTokenToEthOutputPrice(_ethAmount);
		return (ethAmount * 10**18) / _ethAmount;
	}

	/**
	 * get the buy price of DAI on Eth2Dai
	 * @param uin256 amount of ETH being spent in wei
	 * @return uint256 returned as a rate in wei
	 */
	function getEth2DaiBuyPrice(
		uint256 _ethAmount
	)
	public 
	view 
	returns(
		uint256 _rate
	) {
		uint256 tokenAmount = eth2dai.getBuyAmount(DAI, WETH, _ethAmount);
		return (tokenAmount * 10**18) / _ethAmount;
	}

	/**
	 * get the sell price of DAI on Eth2Dai
	 * @param uin256 amount of ETH being purchased in wei
	 * @return uint256 returned as a rate in wei
	 */
	function getEth2DaiSellPrice(
		uint256 _ethAmount
	)
	public 
	view 
	returns(
		uint256 _rate
	) {
		uint256 ethAmount = eth2dai.getPayAmount(DAI, WETH, _ethAmount);
		return (ethAmount * 10**18) / _ethAmount;
	}

	/**
	 * get the buy price of DAI on Bancor
	 * @param uint256 amount of ETH being spent in wei
	 * @return uint256 returned as a rate in wei
	 */
	function getBancorBuyPrice(
		uint256 _ethAmount
	)
	public 
	view 
	returns(
		uint256 _rate
	) {
		//convert from eth to bnt
		//parse tuple return value
		uint256 bntAmount;
		(bntAmount,) = bancor.getReturn(BANCORETH, BNT, _ethAmount);
		//convert from bnt to eth
		uint256 tokenAmount = bancordai.getReturn(BNT, DAI, bntAmount);
		return (tokenAmount * 10**18) / _ethAmount;
	}

	/**
	 * get the sell price of DAI on Bancor
	 * @param uint256 amount of ETH being purchased in wei
	 * @return uint256 returned as a rate in wei
	 */
	function getBancorSellPrice(
		uint256 _ethAmount
	)
	public 
	view 
	returns(
		uint256 _rate
	) {
		//get an approximate token amount to calculate ETH returned
		//if there is no recent price, calc current bancor buy price
		uint256 recentRate;
		if (block.number > latestPriceAtBlock + 100) {
			recentRate = getBancorBuyPrice(_ethAmount);
		} else {
			recentRate = latestRate;	
		}
		uint256 roughTokenAmount = (recentRate * _ethAmount) / 10**18;
		//convert from dai to bnt
		uint256 bntAmount = bancordai.getReturn(DAI, BNT, roughTokenAmount);
		//convert from bnt to eth
		//parse tuple return value
		uint256 ;
		(ethAmount,) = bancor.getReturn(BNT, BANCORETH, bntAmount);
		return (ethAmount * _ethAmount) / 10**18;
	}

	/**
	 * get the buy price of DAI on Kyber
	 * @param uint256 amount of ETH being spent in wei
	 * @return uint256 returned as a rate in wei
	 */
	function getKyberBuyPrice(
		uint256 _ethAmount
	)
	public 
	view
	returns(
		uint256 _rate,
		uint256 _reserveAddress
	) {
		return kyber.searchBestRate(KYBERETH, DAI, _ethAmount, true);
	}

	/**
	 * get the sell price of DAI on Kyber
	 * @param uint256 amount of ETH being purchased in wei
	 * @return uint256 returned as a rate in wei
	 */
	function getKyberSellPrice(
		uint256 _ethAmount
	)
	public 
	view
	returns(
		uint256 _rate,
		uint256 _reserveAddress
	) {
		//get an approximate token amount to calculate ETH returned
		//if there is no recent price, calc current kyber buy price
		uint256 recentRate;
		if (block.number > latestPriceAtBlock + 100) {
			(,recentRate) = getKyberBuyPrice(_ethAmount);
		} else {
			recentRate = latestRate;	
		}
		uint256 ethAmount;
		uint256 reserveAddress;
		(reserveAddress, ethAmount) kyber.searchBestRate(DAI, KYBERETH, _ethAmount, true);
		return (ethAmount * _ethAmount) / 10**18;
	}

	////////////
	//FALLBACK//
	////////////

	/**
	 * non-payable fallback function
	 */
	function() external {}

}