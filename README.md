# Oshigoto Contracts
## Overview
Our project, "Oshigoto," aims to create an economic zone within the metaverse to support fan activities. This repository contains test contracts intended for an EVM environment.

![Oshigoto](./assets/proto-1.png)

## About ERC-7631

![ERC-7631](./assets/erc7631.png)

> A fungible ERC-20 token contract and non-fungible ERC-721 token contract can be interlinked, allowing actions performed on one contract to be reflected on the other. This proposal defines how the relationship between the two token contracts can be queried. It also enables accounts to configure whether ERC-721 mints and transfers should be skipped during ERC-20 to ERC-721 synchronization.
> - [ERC-7631, Abstract](https://eips.ethereum.org/EIPS/eip-7631)

## About ERC-6551

This system is designed to generate ERC-6551 accounts linked to membership cards issued under ERC-721. It is intended to be issued for each creator. The wallet is capable of receiving tokens issued through ERC-7631.

> The system outlined in this proposal has two main components:
> - A singleton registry for token bound accounts
> - A common interface for token bound account implementations
> The following diagram illustrates the relationship between NFTs, NFT holders, token bound accounts, and the Registry:


![ERC-6551](./assets/erc6551-diagram.png)

## About Oshigoto Token

This is a donation contract using ERC7631. It is a system where fans can donate to creators using ERC20 or native tokens and receive omikuji or points in return.

![Oshigoto Token](./assets/oshigoto-token.png)

Automatically generated NFTs can be merged with NFTs intended for fan club members. Additionally, these NFTs are managed on-chain. Of course, membership and automatically generated NFTs can also be sold and purchased through the market.

![Membership](./assets/membership.png)

## Contracts
| Contract                                                 | Description            | Deployed |
| -------------------------------------------------------- | ---------------------- | -------- |
| [CheckCoin](./src/CheckCoin.sol)                         | ERC-20 Demo Token       | [0xDB9D73B5e559C541b78b08091C41e7EC4519232b](https://sepolia.etherscan.io/token/0xDB9D73B5e559C541b78b08091C41e7EC4519232b)  |
| [OshigotoToken](./src/OshigotoToken.sol)                 | ERC-7631               | [0xF01C3aFb034940d50f4767526032c02569719233](https://sepolia.etherscan.io/token/0xF01C3aFb034940d50f4767526032c02569719233)  |
| [OshigotoMembership](./src/OshigotoMembership.sol)       | ERC-721 Token           | [0xd3298fb42f7DC971475F5Bf01271Ef60Cf47257D](https://sepolia.etherscan.io/token/0xd3298fb42f7DC971475F5Bf01271Ef60Cf47257D)  |
| [OshigotoGoodsExchange](./src/OshigotoGoodsExchange.sol) | ERC-5192 Token         | [0x25A3d7d8FFCD90895Abb3f96fe64F6c61a5430EE](https://sepolia.etherscan.io/token/0x25A3d7d8FFCD90895Abb3f96fe64F6c61a5430EE) |
| [MetaLivePOAP](./src/MetaLivePOAP.sol)                   | ERC-5192 Token         | [0x1e23D186C33A6222eD10b43daDfcF9ACD04392AE](https://sepolia.etherscan.io/token/0x1e23D186C33A6222eD10b43daDfcF9ACD04392AE) |
| [ERC5192](./src/ERC5192.sol)                             | ERC-5192 (SBT)          | -  |
| [ERC6551Registry](./src/ERC6551Registry.sol)             | ERC-6551 Registry       | [0xfba610bC413b39B16aAFc2Eb7AF5063b5664547E](https://sepolia.etherscan.io/token/0xfba610bC413b39B16aAFc2Eb7AF5063b5664547E)  |
| [TokenBoundAccount](./src/TokenBoundAccount.sol)         | ERC-6551 Implementation | [0x43D6F857C7a1cf350ed6f4543C0f7646506E890E](https://sepolia.etherscan.io/token/0x43D6F857C7a1cf350ed6f4543C0f7646506E890E)  |
| [DN404Mirror](./src/dn404/DN404Mirror.sol)              | ERC-7631 (ERC-721)               | [0x1A5db3AEFE70149b5927b96e070088A76dD8731d](https://sepolia.etherscan.io/token/0x1A5db3AEFE70149b5927b96e070088A76dD8731d)  |

## Tech Stack
- UE5
- HTTP Plugin
- Solidity
- Foundry
- ERC-7631（a.k.a DN404）
- ERC-6551
- ERC-5192 (a.k.a SBT(Soulbound Token))
- Web3.py
- FastAPI
- Python
- Azure Container Apps

## API

- [Oshigoto API](https://github.com/yuk6ra/oshigoto-backend)

## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

## Development

### Deploy sample contracts

```shell
make test
```

```shell
make deploy-checkcoin
make deploy-erc6551
make deploy-tba
```

### Deploy Oshigoto Token

.env
```shell
CHECKCOIN_ADDRESS=<your_checkcoin_address>
```

```shell
make deploy-oshigototoken
```
### Deploy Oshigoto Membership

```.env
OSHIGOTO_TOKEN_ADDRESS=<your_oshigoto_token_address>
```

```shell
make deploy-membership
```

*You need to execute `setApprovalForAll` to allow the contract to transfer the NFT.

### Deploy Oshigoto Goods Exchange

```shell
make deploy-goods
```

### Deploy MetaLivePOAP
```shell
make deploy-poap
```

### Verify Contract

example:
```shell
forge verify-contract --etherscan-api-key ${KEY} ${CONTRACT_ADDRESS} ./src/LoginCoin.sol:LoginCoin  --chain 11155111
```

## References
- Pandora Contract: [0x9E9FbDE7C7a83c43913BddC8779158F1368F0413](https://etherscan.io/address/0x9e9fbde7c7a83c43913bddc8779158f1368f0413#code)
- Vitalik, Soulbound, https://vitalik.eth.limo/general/2022/01/26/soulbound.html
- [DN404](https://github.com/Vectorized/dn404)
- [ERC-7631](https://eips.ethereum.org/EIPS/eip-7631)
- [ERC-6551](https://eips.ethereum.org/EIPS/eip-6551)
- [ERC-5192](https://eips.ethereum.org/EIPS/eip-5192)