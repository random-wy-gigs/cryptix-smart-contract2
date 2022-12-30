// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./interfaces/ICryptix.sol";
import "./CryptixEvent.sol";

contract CrytpixMarketplace {
    // uint256 listingPrice = 0.025 ether;
    uint256 listingPrice = 3; // percent chare
    uint256 createPrice = 6; // percent chare
    address payable owner;
    mapping(uint256 => ICryptix.Event) idToEvent;

    using Counters for Counters.Counter;
    Counters.Counter private _eventIds;
    // Counters.Counter private _ticketsSold;

    event EventCreated(uint256 indexed eventId, address host);

    event EventListed(uint256 indexed eventId, address host);

    constructor() {
        owner = payable(msg.sender);
    }

    function CreateEvent(
        string memory title,
        string memory symbol,
        string memory data,
        ICryptix.InTicket[] calldata _tickets
    ) public payable returns (uint256) {
        uint256 totalAmount = 0;
        uint256 totalTickets = 0;
        for (uint256 i = 0; i < _tickets.length; i++) {
            totalAmount += _tickets[i].price * _tickets[i].number;
            totalTickets += _tickets[i].number;
        }
        require(
            msg.value >= (totalAmount * createPrice) / 100,
            "Amount must valid"
        );
        owner.transfer(msg.value);
        CryptixEvent new_event = new CryptixEvent(
            payable(msg.sender),
            title,
            symbol
            // _tickets
        );
        _eventIds.increment();
        uint256 newEventId = _eventIds.current();
        ICryptix.Event storage cEvent = idToEvent[newEventId];
        // ICryptix.Ticket[] memory tickets = _tickets;
        cEvent.eventId = newEventId;
        cEvent.eventAddress = address(new_event);
        for (uint256 i = 0; i < _tickets.length; i++) {
            cEvent.tickets.push(
                ICryptix.Ticket(
                    1,
                    _tickets[i].number,
                    0,
                    _tickets[i].name,
                    _tickets[i].price,
                    _tickets[i].descUri
                )
            );
        }
        cEvent.totalAmount = totalAmount;
        cEvent.totalTickets = totalTickets;
        cEvent.soldTickets = 0;
        cEvent.host = payable(msg.sender);
        cEvent.listed = false;
        cEvent.dataUri = data;
        return newEventId;
    }

    /* Updates the listing price of the contract */
    function updateListingPrice(uint256 _listingPrice) public payable {
        require(
            owner == msg.sender,
            "Only marketplace admin can update listing price."
        );
        listingPrice = _listingPrice;
    }

    /* Updates the listing price of the contract */
    function updateCreatePrice(uint256 _price) public payable {
        require(
            owner == msg.sender,
            "Only marketplace admin can update listing price."
        );
        createPrice = _price;
    }

    /* Returns the listing price of the contract */
    function getListingPrice() public view returns (uint256) {
        return listingPrice;
    }

    /* Returns the create price of the contract */
    function getCreatePrice() public view returns (uint256) {
        return createPrice;
    }

    function ListEvent(uint256 eventId) public payable returns (uint256) {
        require(
            idToEvent[eventId].host == msg.sender,
            "Only the event host can list an event"
        );
        require(idToEvent[eventId].listed == false, "Event already listed");
        // require(msg.value == listingPrice, "Invalid listing price");
        require(
            msg.value >= (idToEvent[eventId].totalAmount * listingPrice) / 100,
            "Invalid listing price"
        );
        owner.transfer(msg.value);
        idToEvent[eventId].listed = true;
        emit EventListed(eventId, msg.sender);
        return eventId;
    }

    /* allows someone to resell a token they have purchased */
    // function resellToken(uint256 tokenId, uint256 price) public payable {
    //   require(idToMarketItem[tokenId].owner == msg.sender, "Only item owner can perform this operation");
    //   require(msg.value == listingPrice, "Price must be equal to listing price");
    //   idToMarketItem[tokenId].sold = false;
    //   idToMarketItem[tokenId].price = price;
    //   idToMarketItem[tokenId].seller = payable(msg.sender);
    //   idToMarketItem[tokenId].owner = payable(address(this));
    //   _itemsSold.decrement();

    //   _transfer(msg.sender, address(this), tokenId);
    // }

    /* Creates the sale of a marketplace item */
    /* Transfers ownership of the item, as well as funds between parties */
    /* ::TODO:: Mints a new item in the event collecton, then transfer it tto the buyer */
    // function sellTicket(uint256 eventId) public payable {
    //     uint price = idToEvent[eventId].price;
    //     address seller = idToEvent[eventId].host;
    //     require(msg.value == price, "Amount must be equal to ticket price");
    //     idToEvent[eventId].owner = payable(msg.sender);
    //     idToEvent[eventId].sold = true;
    //     idToEvent[eventId].seller = payable(address(0));
    //     _itemsSold.increment();
    //     _transfer(address(this), msg.sender, tokenId);
    //     payable(owner).transfer(listingPrice);
    //     payable(seller).transfer(msg.value);
    // }

    /* Returns all unsold market items */
    /* ::TODO:: rewrite Returns all unsold market items */
    function fetchListedEvents() public view returns (ICryptix.Event[] memory) {
        uint256 eventsCount = _eventIds.current();
        uint256 unsoldEventsCount = 0;
        uint256 currentIndex = 0;
        for (uint256 i = 0; i < eventsCount; i++) {
            if (
                idToEvent[i + 1].listed &&
                idToEvent[i + 1].soldTickets >= idToEvent[i + 1].totalTickets
            ) {
                unsoldEventsCount += 1;
            }
        }
        ICryptix.Event[] memory events = new ICryptix.Event[](
            unsoldEventsCount
        );
        for (uint256 i = 0; i < eventsCount; i++) {
            if (
                idToEvent[i + 1].listed &&
                idToEvent[i + 1].soldTickets >= idToEvent[i + 1].totalTickets
            ) {
                uint256 currentId = i + 1;
                ICryptix.Event storage currentEvent = idToEvent[currentId];
                events[currentIndex] = currentEvent;
                currentIndex += 1;
            }
        }
        return events;
    }

    /* Returns only items that a user has purchased */
    // function fetchMyNFTs() public view returns (CEvent[] memory) {
    //   uint totalItemCount = _eventIds.current();
    //   uint itemCount = 0;
    //   uint currentIndex = 0;

    //   for (uint i = 0; i < totalItemCount; i++) {
    //     if (idToMarketItem[i + 1].owner == msg.sender) {
    //       itemCount += 1;
    //     }
    //   }

    //   MarketItem[] memory items = new MarketItem[](itemCount);
    //   for (uint i = 0; i < totalItemCount; i++) {
    //     if (idToMarketItem[i + 1].owner == msg.sender) {
    //       uint currentId = i + 1;
    //       MarketItem storage currentItem = idToMarketItem[currentId];
    //       items[currentIndex] = currentItem;
    //       currentIndex += 1;
    //     }
    //   }
    //   return items;
    // }

    /* Returns only items a user has listed */
    // function fetchItemsListed() public view returns (CEvent[] memory) {
    //   uint totalItemCount = _eventIds.current();
    //   uint itemCount = 0;
    //   uint currentIndex = 0;

    //   for (uint i = 0; i < totalItemCount; i++) {
    //     if (idToMarketItem[i + 1].seller == msg.sender) {
    //       itemCount += 1;
    //     }
    //   }

    //   CEvent[] memory items = new MarketItem[](itemCount);
    //   for (uint i = 0; i < totalItemCount; i++) {
    //     if (idToMarketItem[i + 1].seller == msg.sender) {
    //       uint currentId = i + 1;
    //       MarketItem storage currentItem = idToMarketItem[currentId];
    //       items[currentIndex] = currentItem;
    //       currentIndex += 1;
    //     }
    //   }
    //   return items;
    // }

    /* Returns only events a host has listed */
    function fetchMyListedEvents()
        public
        view
        returns (ICryptix.Event[] memory)
    {
        uint256 totalEventsCount = _eventIds.current();
        uint256 eventCount = 0;
        uint256 currentIndex = 0;

        for (uint256 i = 0; i < totalEventsCount; i++) {
            if (
                idToEvent[i + 1].host == msg.sender && idToEvent[i + 1].listed
            ) {
                eventCount += 1;
            }
        }

        ICryptix.Event[] memory events = new ICryptix.Event[](eventCount);
        for (uint256 i = 0; i < totalEventsCount; i++) {
            if (
                idToEvent[i + 1].host == msg.sender && idToEvent[i + 1].listed
            ) {
                uint256 currentId = i + 1;
                ICryptix.Event storage currentEvent = idToEvent[currentId];
                events[currentIndex] = currentEvent;
                currentIndex += 1;
            }
        }
        return events;
    }

    /* Returns only events a host has created */
    function fetchMyEvents() public view returns (ICryptix.Event[] memory) {
        uint256 totalEventsCount = _eventIds.current();
        uint256 eventCount = 0;
        uint256 currentIndex = 0;

        for (uint256 i = 0; i < totalEventsCount; i++) {
            if (idToEvent[i + 1].host == msg.sender) {
                eventCount += 1;
            }
        }

        ICryptix.Event[] memory events = new ICryptix.Event[](eventCount);
        for (uint256 i = 0; i < totalEventsCount; i++) {
            if (idToEvent[i + 1].host == msg.sender) {
                uint256 currentId = i + 1;
                ICryptix.Event storage currentEvent = idToEvent[currentId];
                events[currentIndex] = currentEvent;
                currentIndex += 1;
            }
        }
        return events;
    }
}
