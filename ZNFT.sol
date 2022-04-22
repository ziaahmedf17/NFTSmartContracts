// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract ZNFT is ERC721, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;

    uint256 public mintRate = 0.01 ether;
    uint public MAX_SUPPLY = 1;

    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("ZNFT", "ZT") {}

    function _baseURI() internal pure override returns (string memory) {
        return "https://ziaahmed.dev/token";
    }

    function safeMint(address to) public payable {
        require(totalSupply() < MAX_SUPPLY, "Can't mint more");
        require(msg.value >= mintRate, "Not enough ether sent");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function withdraw() public onlyOwner
    {
        require(address(this).balance > 0, "Balance is 0");
        payable(owner()).transfer(address(this).balance);
    }
}
