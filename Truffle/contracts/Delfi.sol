pragma solidity ^0.5.4;

//////////////
//INTERFACES//
//////////////

contract ERC20 {
	function balanceOf(address _owner) external view returns(uint256 _amount) {}
}

contract Uniswap {
	function getEthToTokenInputPrice(uint256 _amount) external view returns(uint256 _tokenAmount) {}
	function getTokenToEthOutputPrice(uint256 _amount) external view returns(uint256 _tokenAmount) {}
}

contract Eth2Dai {
	function getBuyAmount(address _tokenFrom, address _tokenTo, uint256 _amount) external view returns(uint256 _tokenAmount) {}
	function getPayAmount(address _tokenFrom, address _tokenTo, uint256 _amount) external view returns(uint256 _tokenAmount) {}
}

contract Bancor {
	function getReturn(address _tokenFrom, address _tokenTo, uint256 _amount) external view returns(uint256 _tokenAmount, uint256 _blank) {}
}

contract BancorDai {
	function getReturn(address _tokenFrom, address _tokenTo, uint256 _amount) external view returns(uint256 _tokenAmount) {}
}

contract Kyber {
	function searchBestRate(address _tokenFrom, address _tokenTo, uint256 _amount, bool _isPermissionless) external view returns(address _reserveAddress, uint256 _tokenAmount) {}
}

/////////////////
//MAIN CONTRACT//
/////////////////

contract Delphi {

	using SafeMath for uint256;

	///////////////////
	//STATE VARIABLES//
	///////////////////

	uint256 public latestRate;
	uint256 public latestRateAtBlock;
	
	address constant public DAI = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;
	address constant public WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
	address constant public BNT = 0x1F573D6Fb3F13d689FF844B4cE37794d79a7FF1C;
	address constant public UNISWAP = 0x09cabEC1eAd1c0Ba254B09efb3EE13841712bE14;
	address constant public ETH2DAI = 0x39755357759cE0d7f32dC8dC45414CCa409AE24e;
	address constant public BANCOR = 0xCBc6a023eb975a1e2630223a7959988948E664f3;
	address constant public BANCORDAI = 0x587044b74004E3D5eF2D453b7F8d198d9e4cB558;
	address constant public BANCORETH = 0xc0829421C1d260BD3cB3E0F06cfE2D52db2cE315;
	address constant public KYBER = 0x9ae49C0d7F8F9EF4B864e004FE86Ac8294E20950;
	address constant public KYBERETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
	address constant public KYBER_OASIS_RESERVE = 0x04A487aFd662c4F9DEAcC07A7B10cFb686B682A4;
	address constant public KYBER_UNISWAP_RESERVE = 0x13032DeB2d37556cf49301f713E9d7e1d1A8b169;


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
	 * @param _token address of token contract
	 * @param _owner address of token holder
	 * @return _tokenAmount token balance of holder in smallest unit
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
		ERC20 token = ERC20(_token);
		return token.balanceOf(_owner);
	}

	/**
	 * get the non-token ETH balance of an address
	 * @param _owner address to check
	 * @return _ethAmount amount in wei
	 */
	function getEthBalance(
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
	 * @param _ethAmount amount of ETH being spent in wei
	 * @return _rate returned as a rate in wei
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
	 * @param _ethAmount amount of ETH being purchased in wei
	 * @return _rate returned as a rate in wei
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
	 * @param _ethAmount amount of ETH being spent in wei
	 * @return _rate returned as a rate in wei
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
	 * @param _ethAmount amount of ETH being purchased in wei
	 * @return _rate returned as a rate in wei
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
	 * @param _ethAmount amount of ETH being spent in wei
	 * @return _rate returned as a rate in wei
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
	 * @param _ethAmount amount of ETH being purchased in wei
	 * @return _rate returned as a rate in wei
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
		if (block.number > latestRateAtBlock + 100) {
			recentRate = getBancorBuyPrice(_ethAmount);
		} else {
			recentRate = latestRate;	
		}
		uint256 roughTokenAmount = (recentRate * _ethAmount) / 10**18;
		//convert from dai to bnt
		uint256 bntAmount = bancordai.getReturn(DAI, BNT, roughTokenAmount);
		//convert from bnt to eth
		//parse tuple return value
		uint256 ethAmount;
		(ethAmount,) = bancor.getReturn(BNT, BANCORETH, bntAmount);
		return (10**18 * roughTokenAmount) / ethAmount;
	}

	/**
	 * get the buy price of DAI on Kyber
	 * @param _ethAmount amount of ETH being spent in wei
	 * @return _reserveAddress reserve address with best rate
	 * @return _rate returned as a rate in wei
	 */
	function getKyberBuyPrice(
		uint256 _ethAmount
	)
	public 
	view
	returns(	
	    address _reserveAddress,
		uint256 _rate
	) {
		return kyber.searchBestRate(KYBERETH, DAI, _ethAmount, true);
	}

	/**
	 * get the sell price of DAI on Kyber
	 * @param _ethAmount amount of ETH being purchased in wei
	 * @return _reserveAddress reserve address with best rate
	 * @return _rate returned as a rate in wei
	 */
	function getKyberSellPrice(
		uint256 _ethAmount
	)
	public 
	view
	returns(
		address _reserveAddress,
		uint256 _rate
	) {
		//get an approximate token amount to calculate ETH returned
		//if there is no recent price, calc current kyber buy price
		uint256 recentRate;
		if (block.number > latestRateAtBlock + 100) {
			(,recentRate) = getKyberBuyPrice(_ethAmount);
		} else {
			recentRate = latestRate;	
		}
		uint256 ethAmount;
		address reserveAddress;
		(reserveAddress, ethAmount) = kyber.searchBestRate(DAI, KYBERETH, _ethAmount, true);
	    uint256 tokenAmount = (_ethAmount * 10**18) / ethAmount;
	    return (reserveAddress, (tokenAmount * 10**18) / _ethAmount);
	}

	/**
	 * formula that returns the current spot price and economic value
	 * @param _ethAmount amount of eth in wei
	 * @param _percent price movement as a percentage
	 * @return _rate current weighted spot price in wei
	 * @return _costToMoveXPercent cost in wei to move influence the price by _percent
	 */
	function getCurrentRate(
		uint256 _ethAmount,
		uint256 _percent
	) 
	view 
	external 
	returns(
		uint256 _rate,
		uint256 _costToMoveXPercent
	) {
		require (_percent >= 0 && _percent <= 100, "input must be a valid percentage");
		
		//find midpoints of each spread
		uint256 uniswapMidPoint = findMidPoint(getUniswapBuyPrice(_ethAmount), getUniswapSellPrice(_ethAmount));
		uint256 bancorMidPoint = findMidPoint(getBancorBuyPrice(_ethAmount), getBancorBuyPrice(_ethAmount));
		uint256 eth2daiMidPoint = findMidPoint(getEth2DaiBuyPrice(_ethAmount), getEth2DaiSellPrice(_ethAmount));

		//find liquidity of pooled exchanges
		uint256 uniswapLiquidity = getEthBalance(UNISWAP);
		uint256 bancorLiquidity = getTokenBalance(BANCORETH, BANCORDAI);

		//cost of percent move for pooled exchanges
		uint256 costOfPercentMoveUniswap = (uniswapLiquidity * _percent) / 100;
		uint256 costOfPercentMoveBancor = (bancorLiquidity * _percent) / 100;

		//cost of percent move for orderbook exchanges
		uint256 costOfPercentMoveEth2Dai = _ethAmount;
		uint256 diffOfPercentMove = (eth2daiMidPoint * _percent) / 100; //eth amount of x% move
		bool thresholdFound;

		//loop through order book to figure out bid size that moves order book more than _percent
		while (!thresholdFound) {
			if (getEth2DaiBuyPrice(costOfPercentMoveEth2Dai) <= eth2daiMidPoint - diffOfPercentMove) {
				thresholdFound = true;	
			} else {
				costOfPercentMoveEth2Dai += 10**19; //10 ETH steps;
			}
		}

		//information stored in memory arrays to avoid stack depth issues
		uint256[3] memory midPointArray = [uniswapMidPoint, bancorMidPoint, eth2daiMidPoint];
		uint256[3] memory costOfPercentMoveArray = [costOfPercentMoveUniswap, costOfPercentMoveBancor, costOfPercentMoveEth2Dai];

		//calc rate and cost to move 
		return calcRatio(
			midPointArray,
			costOfPercentMoveArray
		);
	}
	
	/**
	 * continue calculation of weighted rate and cost to move market
	 * @param _midPointArray array of spot price midpoints
	 * @param _costOfPercentMoveArray array of wei cost to move each exchange _percent
	 * @return _rate current weighted spot price in wei
	 * @return _costToMoveXPercent cost in wei to move influence the price by _percent
	 */
	function calcRatio(
			uint256[3] memory _midPointArray,
			uint256[3] memory _costOfPercentMoveArray
	) 
	pure
	internal
	returns(
		uint256 _rate,
		uint256 _costToMoveXPercent
	)
	{
		uint256 totalCostOfPercentMove = _costOfPercentMoveArray[0] + _costOfPercentMoveArray[1] + _costOfPercentMoveArray[2];
		
		//calculated proportion of each exchange in the forumla
		uint256 precision = 10000; //precise to two decimals
		uint256[3] memory propotionArray;
		propotionArray[0] = (_costOfPercentMoveArray[0] * precision) / totalCostOfPercentMove;
		propotionArray[1] = (_costOfPercentMoveArray[1] * precision) / totalCostOfPercentMove;
		propotionArray[2] = (_costOfPercentMoveArray[2] * precision) / totalCostOfPercentMove;

		//balance prices
		uint256 balancedRate = 
			(
				(_midPointArray[0] * propotionArray[0]) + 
				(_midPointArray[1] * propotionArray[1]) + 
				(_midPointArray[2] * propotionArray[2])
			) 
			/ precision;

		return (balancedRate, totalCostOfPercentMove);
	}


	/////////////
	//UTILITIES//
	/////////////
	
	/**
	 * utility function to find mean of an array of values
	 * @param  _data array of values
	 * @return _mean average value;
	 */
	//@dev is this function needed?
	function findMean(
		uint256[] memory _data
	) 
	internal 
	pure 
	returns(
		uint256 _mean
	) {
		require (_data.length >= 2);
		uint256 sum;
		for (uint256 i = 0; i < _data.length; i++) {
			sum = sum.add(_data[i]);
		}
		return sum / _data.length;
	}

	/**
	 * utility function to find mean of an array of values
	 * @param _a first value
	 * @param _b second value
	 * @return _midpoint average value
	 */
	function findMidPoint(
		uint256 _a, 
		uint256 _b
	) 
	internal 
	pure 
	returns(
		uint256 _midpoint
		) {
		//@dev Q is safemath needed here?
		return (_a.add(_b)).div(2);
	}


	////////////
	//FALLBACK//
	////////////

	/**
	 * non-payable fallback function
	 */
	function() external {}

}

/**
 * @title SafeMath
 * @dev Unsigned math operations with safety checks that revert on error
 */
library SafeMath {
    /**
     * @dev Multiplies two unsigned integers, reverts on overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    /**
     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Adds two unsigned integers, reverts on overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

    /**
     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
     * reverts when dividing by zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}
