// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// import "@openzeppelin/contracts/utils/Counters.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

interface ICryptix {
    struct Ticket {
      uint256 ticketId;//just unique number for easy identification
      uint256 number;
      uint256 sold;
      string name;
      uint256 price;
    }
    struct Event {
        uint256 eventId;
        address eventAddress;
        ICryptix.Ticket[] tickets;
        uint256 totalAmount;
        uint256 totalTickets;
        uint256 soldTickets;
        address payable host;
        string dataUri;
        bool listed;
    }
}