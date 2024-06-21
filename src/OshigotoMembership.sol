// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Ownable} from "openzeppelin-contracts/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";
import {ERC721} from "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {Base64} from "openzeppelin-contracts/contracts/utils/Base64.sol";
import {Strings} from "openzeppelin-contracts/contracts/utils/Strings.sol";
import {OshigotoToken} from "./OshigotoToken.sol";
import {DN404Mirror} from "./dn404/DN404Mirror.sol";

contract OshigotoMembership is ERC721, Ownable, ReentrancyGuard {
    uint256 public totalSupply;

    string public oshi_name;

    OshigotoToken public oshigotoToken;
    DN404Mirror public dn404Mirror;

    // Membership
    struct MembershipConfig {
        uint256 burnPoint;
        uint256 lastBurned;
    }

    mapping(uint256 => MembershipConfig) public membershipConfigs;

    mapping(address => uint256) public tokenIds;

    mapping(address => bool) public isMaterialContractAddress;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _oshi_name,
        address _oshigotoTokenAddress
    ) ERC721(_name, _symbol) Ownable(msg.sender) {
        oshi_name = _oshi_name;
        oshigotoToken = OshigotoToken(payable(_oshigotoTokenAddress));
        dn404Mirror = DN404Mirror(payable(address(oshigotoToken.mirrorERC721())));
    }

    function mintMembership() external nonReentrant {
        // require(tokenIds[msg.sender] == 0, "Membership already minted");

        membershipConfigs[totalSupply] = MembershipConfig({
            burnPoint: 0,
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

        uint256 diff = block.timestamp - membershipConfigs[tokenId].lastBurned;
        string memory image = "";

        if (diff < 3 minutes) {
            image = "https://bafybeicdgohbob4jqm5tdhsjyhnctmhu5niedbjmd7u3grivzwto4ogfxy.ipfs.dweb.link/";
        } else if (diff < 5 minutes) {
            image = "https://bafybeieyj6woxz2wqbneglkmnittnrt6pdmte3qx5qumtpgbwpr4dcfmcm.ipfs.dweb.link/";
        } else {
            image = "https://bafybeigjbiob7sgtmikg2lygwh3wgd42io72fpimx4tnkwu6hi5rg434mm.ipfs.dweb.link/";
        }

        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"', oshi_name, ' Membership #', Strings.toString(tokenId),
                                '", "description": "', oshi_name, ' Membership NFTs',
                                '", "image" : "', image,
                                '"}'
                            )
                        )
                    )
                )
            );
    }

    function levelUp(uint256 membershipTokenId, uint256 materialTokenId, address materialContractAddress) external {
        require(ownerOf(membershipTokenId) == msg.sender, "Only owner can level up");
        require(isMaterialContractAddress[materialContractAddress], "Only material contract can level up");
        
        membershipConfigs[membershipTokenId].burnPoint += oshigotoToken.rankOf(materialTokenId);
        membershipConfigs[membershipTokenId].lastBurned = block.timestamp;

        dn404Mirror.transferFrom(msg.sender, address(0), materialTokenId);
    }

    function setOshigotoTokenAddress(address _address) external onlyOwner {
        oshigotoToken = OshigotoToken(payable(_address));
        dn404Mirror = DN404Mirror(payable(address(oshigotoToken.mirrorERC721())));
    }

    function setMaterialContractAddress(address _address, bool _isMaterial) external onlyOwner {
        isMaterialContractAddress[_address] = _isMaterial;
    }

    function burnPointOf(uint256 tokenId) external view returns (uint256) {
        return membershipConfigs[tokenId].burnPoint;
    }

    function lastBurnedOf(uint256 tokenId) external view returns (uint256) {
        return membershipConfigs[tokenId].lastBurned;
    }
}