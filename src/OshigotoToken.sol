// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./dn404/DN404.sol";
import "./dn404/DN404Mirror.sol";
import {Ownable} from "openzeppelin-contracts/contracts/access/Ownable.sol";
import {Strings} from "openzeppelin-contracts/contracts/utils/Strings.sol";

/**
 * @title SimpleDN404
 * @notice Sample DN404 contract that demonstrates the owner selling fungible tokens.
 * When a user has at least one base unit (10^18) amount of tokens, they will automatically receive an NFT.
 * NFTs are minted as an address accumulates each base unit amount of tokens.
 */
contract OshigotoToken is DN404, Ownable {
    string private _name;
    string private _symbol;
    string private _baseURI;

    string public baseTokenURI = "https://example.com/token/";
    string public dataURI = "https://example.com/data/";

    constructor(
        string memory name_,
        string memory symbol_,
        uint96 initialTokenSupply,
        address initialSupplyOwner
    ) Ownable(msg.sender) {
        _name = name_;
        _symbol = symbol_;

        address mirror = address(new DN404Mirror(msg.sender));
        _initializeDN404(initialTokenSupply, initialSupplyOwner, mirror);
    }

    function name() public view override returns (string memory) {
        return _name;
    }

    function symbol() public view override returns (string memory) {
        return _symbol;
    }

    function _tokenURI(uint256 tokenId) internal view override returns (string memory result) {
        if (bytes(baseTokenURI).length > 0) {
            result = string.concat(baseTokenURI, Strings.toString(tokenId));
        } else {
            uint8 seed = uint8(bytes1(keccak256(abi.encodePacked(tokenId))));
            string memory image;
            string memory color;

            if (seed <= 100) {
                image = "1.gif";
                color = "green";
            } else if (seed <= 160) {
                image = "2.gif";
                color = "blue";
            } else if (seed <= 210) {
                image = "3.gif";
                color = "purple";
            } else if (seed <= 240) {
                image = "4.gif";
                color = "orange";
            } else if (seed <= 255) {
                image = "5.gif";
                color = "red";
            }

            string memory jsonPreImage = string.concat(
                string.concat(
                    string.concat('{"name": "Oshigoto #', Strings.toString(tokenId)),
                    '","","external_url":"","image":"'
                ),
                string.concat(dataURI, image)
            );
            string memory jsonPostImage = string.concat(
                '","attributes":[{"trait_type":"Color","value":"',
                color
            );
            string memory jsonPostTraits = '"}]}';

            result = string.concat(
                        "data:application/json;utf8,",
                        string.concat(
                            string.concat(jsonPreImage, jsonPostImage),
                            jsonPostTraits
                        )
                    );
            }
    }

    // This allows the owner of the contract to mint more tokens.
    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

    function setBaseURI(string calldata baseURI_) public onlyOwner {
        _baseURI = baseURI_;
    }

    function withdraw() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }
}