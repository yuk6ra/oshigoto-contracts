// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Ownable} from "openzeppelin-contracts/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";
import {ERC721} from "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {Base64} from "openzeppelin-contracts/contracts/utils/Base64.sol";
import {Strings} from "openzeppelin-contracts/contracts/utils/Strings.sol";

contract OshigotoMembership is ERC721, Ownable, ReentrancyGuard {
    uint256 public totalSupply;

    string public oshi_name;

    // Membership
    struct MembershipConfig {
        uint256 burnAmount;
        uint256 lastBurned;
    }

    mapping(uint256 => MembershipConfig) public membershipConfigs;

    mapping(address => uint256) public tokenIds;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _oshi_name
    ) ERC721(_name, _symbol) Ownable(msg.sender) {
        oshi_name = _oshi_name;
    }

    function mintMembership() external nonReentrant {
        // require(tokenIds[msg.sender] == 0, "Membership already minted");

        MembershipConfig memory membershipConfigs = MembershipConfig({
            burnAmount: 0,
            lastBurned: block.timestamp
        });

        _safeMint(msg.sender, totalSupply);        
        tokenIds[msg.sender] = totalSupply;
        totalSupply++;
    }

    function getTokenIdFromAddress(address _address) external view returns (uint256) {
        return tokenIds[_address];
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"', oshi_name, ' Membership #', Strings.toString(tokenId),
                                '", "description": "', oshi_name, ' Membership NFTs',
                                '", "external_url": "', ""
                                '", "image" : "', ""
                                '"}'
                            )
                        )
                    )
                )
            );
    }
}