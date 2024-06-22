// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Ownable} from "openzeppelin-contracts/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";
import {Base64} from "openzeppelin-contracts/contracts/utils/Base64.sol";
import {Strings} from "openzeppelin-contracts/contracts/utils/Strings.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {ERC5192} from "./ERC5192.sol";

// @dev Should be an upgradeable contract

contract MetaLivePOAP is ERC5192, Ownable, ReentrancyGuard {

    string public oshi_name;
    string public dataURI;

    uint256 public totalSupply;

    bool private isLocked = true;

    mapping(uint256 => string) public names;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _oshi_name,
        string memory _dataURI
    ) ERC5192(_name, _symbol, isLocked) Ownable(msg.sender) {
        oshi_name = _oshi_name;
        dataURI = _dataURI;
    }

    function airdrop(address _to, string memory _name) external onlyOwner {
        _mintPOAP(_to, _name);
    }

    function _mintPOAP(address _to, string memory _name) private {
        _mint(_to, totalSupply);
        if (isLocked) emit Locked(totalSupply);
        names[totalSupply] = _name;
        totalSupply++;
    }

    function setDataURI(string memory _dataURI) external onlyOwner {
        dataURI = _dataURI;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        _requireOwned(tokenId);

        if (bytes(dataURI).length == 0) {
            return "";
        }

        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"', oshi_name, ' ', names[tokenId], ' POAP #', Strings.toString(tokenId),
                                '", "image" : "', dataURI,
                                '", "attributes": [{"trait_type": "name", "value": "',names[tokenId],'"}]'
                                '}'
                            )
                        )
                    )
                )
            );
    }
}