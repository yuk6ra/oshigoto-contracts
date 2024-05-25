# Oshigoto Contracts
## Overview

## Contracts

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


```shell
make test
```

```shell
make deploy-mock-dn404
```

```shell
make deploy-logincoin
make deploy-oshigototoken
forge verify-contract --etherscan-api-key ${KEY} ${CONTRACT_ADDRESS} ./src/LoginCoin.sol:LoginCoin  --chain 11155111
```

## References
- Pandora Contract: [0x9E9FbDE7C7a83c43913BddC8779158F1368F0413](https://etherscan.io/address/0x9e9fbde7c7a83c43913bddc8779158f1368f0413#code)
- [DN404](https://github.com/Vectorized/dn404)