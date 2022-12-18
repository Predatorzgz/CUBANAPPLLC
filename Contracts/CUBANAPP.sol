// SPDX-License-Identifier: GNU General Public License v3.0
// CUBANAPP LLC TRC1155 Contract

pragma solidity >=0.8.1 <=0.9.0;

import "./Ownable.sol";
import "./TRC1155.sol";
import "./Address.sol";
//import "./Timers.sol";
import "./ITRC20.sol";
import "./ITRC721.sol";
import "./ITRC1155.sol";

/**
 * @dev Main Contract
 * 
 */
contract CUBANAPP is Ownable, TRC1155 {
	using Address for address;
	//using Timers for uint64;
	
	ITRC20 constant usdtToken = ITRC20(address(0x00eca9bc828a3005b9a3b909f2cc5c2a54794de05f));
	// shasta base58 TG3XXyExBkPp9nzdajDZsozEu4BkaSJozs 
	// shasta hex 4142a1e39aefa49290f2b3f9ed688d7cecf86cd6e0
	// nile hex 41eca9bc828a3005b9a3b909f2cc5c2a54794de05f
	// nile base58 TXYZopYRdj2D9XRtbG411XZZ3kM5VkAeBf
	// main base58 TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t
	// main hex 41a614f803b6fd780986a42c78ec9c7f77e6ded13c
	
    string private _name;
    string private _symbol;
	
	error Invalid();
	
	mapping(uint256 => uint256) private _totalSupply;
	
	//event Retire(ITRC20 indexed _token, address indexed _from, address _to, uint256 _amount);
	
	constructor(string memory uri_, string memory name_, string memory symbol_) TRC1155(uri_){
		/*
		[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99];

        [1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000];

		*/
		address owner = _msgSender();
		_mint(owner, 100, 1000, "");
		_name = name_;
		_symbol = symbol_;
	}
	
    receive() external payable {
		revert();
    }
    
    
    fallback() external payable {
		revert();
    }
    
    /**
     * @dev Returns the name of the token.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }
	
	function mint(
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) external onlyOwner returns (bool){
		_mint(to, id, amount, data);
		return true;
    }
	
	function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) external onlyOwner returns (bool){
		_mintBatch(to, ids, amounts, data);
		return true;
	}
	
    /**
     * @dev Total amount of tokens in with a given id.
     */
    function totalSupply(uint256 id) public view virtual returns (uint256) {
        return _totalSupply[id];
    }

    /**
     * @dev Indicates whether any token exist with a given id, or not.
     */
    function exists(uint256 id) public view virtual returns (bool) {
        return _totalSupply[id] > 0;
    }

    /**
     * @dev See {TRC1155-_beforeTokenTransfer}.
     */
    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual override {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);

        if (from == address(0)) {
            for (uint256 i = 0; i < ids.length; ++i) {
                _totalSupply[ids[i]] += amounts[i];
            }
        }

        if (to == address(0)) {
            for (uint256 i = 0; i < ids.length; ++i) {
                uint256 id = ids[i];
                uint256 amount = amounts[i];
                uint256 supply = _totalSupply[id];
                require(supply >= amount, "TRC1155: burn amount exceeds totalSupply");
                unchecked {
                    _totalSupply[id] = supply - amount;
                }
            }
        }
    }

    /**
    *
    * @dev send all trx balance in the contract to owner address
    *
    */
    function reclaimTRX() external onlyOwner returns (bool){
		uint256 balance = address(this).balance;
		require(balance > 0, "Balance is 0");
		
		address to = _msgSender();
        payable(to).transfer(balance);
		return true;
    }
    
     /**
    *
    * @dev send all trx balance in the contract to owner address
    *
    */
    function reclaimTRX() external onlyOwner returns (bool){
		uint256 balance = address(this).balance;
		require(balance > 0, "Balance is 0");
		
		address to = _msgSender();
        payable(to).transfer(balance);
		return true;
    }
    
    /**
    *
    * @dev send all trc10 balance in the contract to owner address
    *
    */
	function reclaimTRC10(trcToken tokenId) external onlyOwner returns (bool){
		uint256 balance = address(this).tokenBalance(tokenId);
		require(balance > 0, "Balance is 0");
		
		address to = _msgSender();
        payable(to).transferToken(balance, tokenId);
		return true;
    }
	
    /**
    * @dev Claim TRC20 balance in the contract to owner address
    */
	function reclaimTRC20(ITRC20 _token) external onlyOwner returns (bool){
		uint256 balance = _token.balanceOf(address(this));
		require(balance > 0, "Balance is 0");
		
		address to = _msgSender();
		_token.transfer(to, balance);

		return true;
	}
	
    /**
    *
    * @dev send NFT balance in the contract to owner address
    *
    */
	function reclaimTRC721(ITRC721 nft_, uint256 tokenId_) external onlyOwner returns (bool){
		uint256 balance = nft_.balanceOf(address(this));
		require(balance > 0, "Balance is 0");
		
		address to = _msgSender();
		nft_.safeTransferFrom(address(this), to, tokenId_);
		return true;
    }
	
    /**
    *
    * @dev send MultiToken balance in the contract to owner address
    *
    */
	function reclaimTRC1155(ITRC1155 nft_, uint256 tokenId_) external onlyOwner returns (bool){
		uint256 balance = nft_.balanceOf(address(this), tokenId_);
		require(balance > 0, "Balance is 0");
		
		address to = _msgSender();
		nft_.safeTransferFrom(address(this), to, tokenId_, balance, "");
		return true;
    }
	
}