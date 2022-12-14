// SPDX-License-Identifier: GNU General Public License v3.0
// CUBANAPP LLC TRC1155 Contract

pragma solidity >=0.8.1 <=0.9.0;

import "./ITRC20.sol";
import "./ITRC165.sol";
import "./ITRC721.sol";
import "./ITRC721Receiver.sol";
import "./ITRC1155.sol";
import "./ITRC1155Receiver.sol";

/**
 * @dev Main Contract
 * 
 */
abstract contract TRCReceiver is ITRC165, ITRC721Receiver, ITRC1155Receiver {
	
	function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(ITRC20).interfaceId ||
        interfaceId == type(ITRC165).interfaceId ||
        interfaceId == type(ITRC1155).interfaceId ||
        interfaceId == type(ITRC1155Receiver).interfaceId ||
        interfaceId == type(ITRC721).interfaceId ||
        interfaceId == type(ITRC721Receiver).interfaceId;
    }
	
    /**
     * @dev See {ITRC721Receiver-onTRC721Received}.
     */
    function onTRC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onTRC721Received.selector;
    }
	
    function onTRC1155Received(
        address,
        address,
        uint256,
        uint256,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onTRC1155Received.selector;
    }

    function onTRC1155BatchReceived(
        address,
        address,
        uint256[] memory,
        uint256[] memory,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onTRC1155BatchReceived.selector;
    }

}