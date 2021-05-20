// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.6.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/utils/Counters.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/access/Ownable.sol";
import "./Rishikesh.sol";

contract Marketplace is Rishikesh, ERC721, Ownable {
    using Counters for Counters.Counter;
   
    Counters.Counter private _tokenIds;

    
    constructor() ERC721("Rishikesh NFT", "RKNFT") public{}

    //Buy ERC20 Tokens i.e Rishikesh Token
    function buyERC20Token(uint256 _quantity) public {
        rtransfer(msg.sender, _quantity);
    }
    
    function mintNFT(address receiver, string memory tokenURI) external onlyOwner returns (uint256) {
        _tokenIds.increment();

        uint256 newNftTokenId = _tokenIds.current();
        _mint(receiver, newNftTokenId);
        _setTokenURI(newNftTokenId, tokenURI);

        return newNftTokenId;
    }
    
    function sellNFT(uint256 _tokenId, address _to) public {
        require(ownerOf(_tokenId) == msg.sender);
        transferFrom(msg.sender, address(this), _tokenId);
        
        //Payment with ERC20 tokens
        //NFT Price = 1
        rtransferFrom(_to, msg.sender, 1);
    }
    
    
    function buyNFT(uint256 _tokenId) public {
        require(msg.sender != address(0) && msg.sender != address(this));

        safeTransferFrom(ownerOf(_tokenId), msg.sender, _tokenId);
        
        //Payment with ERC20 tokens
        //NFT Price = 1
        rtransferFrom(msg.sender, ownerOf(_tokenId), 1);
    }
    
}