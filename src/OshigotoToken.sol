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
    string private _oshi_name;
    string private _baseURI;

    string public dataURI = "https://bafybeig7wwdixqpzaqoxvbagbfxjbzgljzdgwgnufekrwtjeb7cjjvu7n4.ipfs.dweb.link/";
    string public extension = ".json";

    uint256 public priceWithERC20Token = 200 * 10**18;
    uint256 public priceWithNativeToken = 0.0001 ether;
    uint256 public mintAmount = 5 * 10**17;
    IERC20 public paymentToken;

    constructor(
        string memory name_,
        string memory symbol_,
        string memory oshi_name,
        uint96 initialTokenSupply,
        address initialSupplyOwner
    ) Ownable(msg.sender) {
        _name = name_;
        _symbol = symbol_;
        _oshi_name = oshi_name;

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
        uint8 rank = rankOf(tokenId);

        string memory trait;
        if (rank == 1) {
            trait = "common";
        } else if (rank == 2) {
            trait = "uncommon";
        } else if (rank == 3) {
            trait = "rare";
        } else if (rank == 4) {
            trait = "epic";
        } else {
            trait = "legendary";
        }

        string memory json = string.concat(
            '{"name": "', _oshi_name, ' Oshigoto #', Strings.toString(tokenId), '",',
            '"image":"', dataURI, trait, '.png",',
            '"attributes":[{"trait_type":"Type","value":"', trait, '"}, {"trait_type":"Rank","value":"', Strings.toString(rank), '"}]}'
        );

        result = string.concat(
                    "data:application/json;utf8,",
                    json
                );
    }

    // function setPattern(uint256 _pattern_id, uint256 _percentage, string memory _path) public onlyOwner {
    //     patterns[_pattern_id] = Pattern(_percentage, _path);
    // }

    function mintWithERC20Token(address _to) public {
        require(paymentToken.balanceOf(msg.sender) >= priceWithERC20Token, "Insufficient token balance");
        require(paymentToken.allowance(msg.sender, address(this)) >= priceWithERC20Token, "Token allowance too low");

        // @dev Need a target membership

        paymentToken.transferFrom(msg.sender, address(this), priceWithERC20Token);

        _mint(_to, mintAmount);
    }

    function mintWithNativeToken(address _to) public payable {
        require(msg.value >= priceWithNativeToken, "Insufficient payment");

        // @dev Need a target membership

        _mint(_to, mintAmount);
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

    function rankOf(uint256 tokenId) public view returns (uint8) {
        bytes32 seed = mirrorSeedOf(tokenId);
        require(seed != 0, "Seed not found");

        uint8 _seed = uint8(bytes1(seed));
        // @dev rank generation based on rarity
        // if (_seed <= 153) {
        //     return 1;
        // } else if (_seed <= 204) {
        //     return 2;
        // } else if (_seed <= 229) {
        //     return 3;
        // } else if (_seed <= 242) {
        //     return 4;
        // } else {
        //     return 5;
        // }

        // @dev simple rank generation
        if (_seed < 50) {
            return 1;
        } else if (_seed < 100) {
            return 2;
        } else if (_seed < 150) {
            return 3;
        } else if (_seed < 200) {
            return 4;
        } else {
            return 5;
        }
    }
}