// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

interface IMirrorSeed {
    // Get the seed of a token ID
    function mirrorSeedOf(uint256 tokenId) external view returns (bytes32);
}