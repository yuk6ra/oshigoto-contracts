// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Ownable} from "openzeppelin-contracts/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";
import {Base64} from "openzeppelin-contracts/contracts/utils/Base64.sol";
import {Strings} from "openzeppelin-contracts/contracts/utils/Strings.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {ERC5192} from "./ERC5192.sol";

// @dev Should be an upgradeable contract

contract OshigotoGoodsExchange is ERC5192, Ownable, ReentrancyGuard {

    string public oshi_name;
    string public dataURI;
    string public extension = ".png";

    uint256 public totalSupply;
    uint256 public priceGoodsA = 0.1 ether;
    uint256 public priceGoodsB = 0.2 ether;
    uint256 public priceGoodsC = 0.3 ether;
    IERC20 public paymentToken;

    bool private isLocked = true;

    mapping(uint256 => string) public goods;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _oshi_name,
        string memory _dataURI,
        address _paymentToken
    ) ERC5192(_name, _symbol, isLocked) Ownable(msg.sender) {
        oshi_name = _oshi_name;
        dataURI = _dataURI;
        paymentToken = IERC20(_paymentToken);
    }

    function purchaseGoodsA(address _to) external nonReentrant {
        _purchaseGoods(_to, priceGoodsA);
        goods[totalSupply] = "A";
    }

    function purchaseGoodsB(address _to) external nonReentrant {
        _purchaseGoods(_to, priceGoodsB);
        goods[totalSupply] = "B";
    }

    function purchaseGoodsC(address _to) external nonReentrant {
        _purchaseGoods(_to, priceGoodsC);
        goods[totalSupply] = "C";
    }

    function _purchaseGoods(address _to, uint256 _price) internal {
        require(paymentToken.balanceOf(msg.sender) >= _price, "Insufficient balance");
        require(paymentToken.allowance(msg.sender, address(this)) >= _price, "Insufficient allowance");

        paymentToken.transferFrom(msg.sender, address(this), _price);

        _mint(_to, totalSupply);
        if (isLocked) emit Locked(totalSupply);
        totalSupply++;
    }

    function setPaymentTokenAddress(address _paymentToken) external onlyOwner {
        paymentToken = IERC20(_paymentToken);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        _requireOwned(tokenId);

        if (bytes(goods[tokenId]).length == 0) {
            return "";
        }
        
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"', oshi_name, 'Goods #', Strings.toString(tokenId),
                                '", "description": "', 'Goods ', goods[tokenId],
                                '", "image" : "', dataURI, goods[tokenId], extension,
                                '", "attributes": [{"trait_type": "goods type", "value": "', goods[tokenId],
                                '"}'
                            )
                        )
                    )
                )
            );
    }
}