// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

interface IOshigotoToken {
    // Get the rank of a token
    function rankOf(uint256 tokenId) external view returns (uint8);
}