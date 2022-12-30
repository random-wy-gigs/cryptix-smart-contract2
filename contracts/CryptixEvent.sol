// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./interfaces/ICryptix.sol";
contract CryptixEvent is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    // Counters.Counter private _itemsSold;

    // uint256 listingPrice = 0.025 ether;
    address payable owner;
    // string public dataUri;

    // mapping(uint256 => MarketItem) private idToMarketItem;
    // mapping(string => ICryptix.InTicket) public Tickets;
    // struct MarketItem {
    //   uint256 tokenId;
    //   address payable seller;
    //   address payable owner;
    //   uint256 price;
    //   bool sold;
    // }
    // event MarketItemCreated (
    //   uint256 indexed tokenId,
    //   address seller,
    //   address owner,
    //   uint256 price,
    //   bool sold
    // );

    constructor(address payable eventOwner, string memory eventTitle, string memory eventSymbol) ERC721(eventTitle, eventSymbol) {
    // constructor(address payable eventOwner, string memory eventTitle, string memory eventSymbol, ICryptix.InTicket[] memory _tickets) ERC721(eventTitle, eventSymbol) {
        owner = eventOwner;
        // for (uint256 i = 0; i < _tickets.length; i++) {
        //     Tickets[_tickets[i].name] = _tickets[i];
        // }
        // dataUri = eventDataUri;
    }

    /* Mints a token (ticket) */
    function mintTicket(string memory tokenURI) public payable returns (uint) {
      _tokenIds.increment();
      uint256 newTokenId = _tokenIds.current();

      _mint(msg.sender, newTokenId);
      _setTokenURI(newTokenId, tokenURI);
    //   createMarketItem(newTokenId, price);
      return newTokenId;
    }
}
