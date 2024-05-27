// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./dn404/DN404.sol";
import "./dn404/DN404Mirror.sol";
import {Ownable} from "openzeppelin-contracts/contracts/access/Ownable.sol";
import {Strings} from "openzeppelin-contracts/contracts/utils/Strings.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

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

    string public dataURI;
    string public extension = ".json";

    uint256 public priceWithERC20Token = 2000;
    uint256 public priceWithNativeToken = 0.01 ether;
    uint256 public mintAmount = 1 * 10**18;
    IERC20 public paymentToken;

    // struct Pattern {
    //     uint256 percentage;
    //     string path;        
    // }

    // mapping(uint256 => Pattern) public patterns;

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
        uint8 seed = uint8(bytes1(keccak256(abi.encodePacked(tokenId))));
        string memory trait;

        // Example of using patterns
        if (seed <= 153) {
            trait = "common";
        } else if (seed <= 204) {
            trait = "uncommon";
        } else if (seed <= 229) {
            trait = "rare";
        } else if (seed <= 242) {
            trait = "superrare";
        } else {
            trait = "ultrarare";
        }

        string memory json = string.concat(
            '{"name": "Oshigoto #', Strings.toString(tokenId), '",',
            '"external_url":"",',
            '"image":"', dataURI, trait, '.png",',
            '"attributes":[{"trait_type":"Type","value":"', trait, '"}]}'
        );

        result = string.concat(
                    "data:application/json;utf8,",
                    json
                );
    }

    // function setPattern(uint256 _pattern_id, uint256 _percentage, string memory _path) public onlyOwner {
    //     patterns[_pattern_id] = Pattern(_percentage, _path);
    // }

    function mintWithERC20Token() public {
        require(paymentToken.balanceOf(msg.sender) >= priceWithERC20Token, "Insufficient token balance");
        require(paymentToken.allowance(msg.sender, address(this)) >= priceWithERC20Token, "Token allowance too low");

        paymentToken.transferFrom(msg.sender, address(this), priceWithERC20Token);

        _mint(msg.sender, mintAmount);
    }

    function mintWithNativeToken() public payable {
        require(msg.value >= priceWithNativeToken, "Insufficient payment");    
        _mint(msg.sender, mintAmount);
    }

    function ownerMint(address _to, uint256 _amount) public onlyOwner {
        _mint(_to, _amount);
    }

    function airdrop(address[] calldata _recipients, uint256[] calldata _amounts) public onlyOwner {
        require(_recipients.length == _amounts.length, "Array lengths must match");
        for (uint256 i = 0; i < _recipients.length; i++) {
            _mint(_recipients[i], _amounts[i]);
        }
    }

    function setDataURI(string calldata _dataURI) public onlyOwner {
        dataURI = _dataURI;
    }

    function setMintAmount(uint256 _amount) public onlyOwner {
        mintAmount = _amount;
    }

    function setPaymentTokenAddress(address _address) public onlyOwner {
        paymentToken = IERC20(_address);
    }

    function setPriceWithERC20Token(uint256 price) public onlyOwner {
        priceWithERC20Token = price;
    }

    function setPriceWithNativeToken(uint256 price) public onlyOwner {
        priceWithNativeToken = price;
    }

    function withdrawWithNativeToken() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    function withdrawWithERC20Token(address tokenAddress) public onlyOwner {
        IERC20 token = IERC20(tokenAddress);
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }
}