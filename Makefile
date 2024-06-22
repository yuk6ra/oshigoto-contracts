include .env

test: ## Run tests 
	@echo "Running tests"
	forge test --gas-report -vv

deploy-mock-dn404:
	@echo "Deploying contract"
	forge script script/mocks/DeploySimpleDN404.s.sol:SimpleDN404Script --rpc-url ${DEV_RPC_URL} --broadcast --verify -vvvv

deploy-logincoin:
	@echo "Deploying contract"
	forge script script/DeployLoginCoin.s.sol:LoginCoinScript --rpc-url ${DEV_RPC_URL} --broadcast --verify -vvvv

deploy-oshigototoken:
	@echo "Deploying contract"
	forge script script/DeployOshigotoToken.s.sol:OshigotoTokenScript --rpc-url ${DEV_RPC_URL} --broadcast --verify -vvvv

deploy-erc6551:
	@echo "Deploying contract"
	forge script script/DeployERC6551Registry.s.sol:ERC6551RegistryScript --rpc-url ${DEV_RPC_URL} --broadcast --verify -vvvv

deploy-membership:
	@echo "Deploying contract"
	forge script script/DeployOshigotoMembership.s.sol:OshigotoMembershipScript --rpc-url ${DEV_RPC_URL} --broadcast --verify -vvvv

deploy-tba:
	@echo "Deploying contract"
	forge script script/DeployTokenBoundAccount.s.sol:TokenBoundAccountScript --rpc-url ${DEV_RPC_URL} --broadcast --verify -vvvv

deploy-checkcoin:
	@echo "Deploying contract"
	forge script script/DeployCheckCoin.s.sol:CheckCoinScript --rpc-url ${DEV_RPC_URL} --broadcast --verify -vvvv

deploy-goods:
	@echo "Deploying contract"
	forge script script/DeployOshigotoGoodsExchange.s.sol:OshigotoGoodsExchangeScript --rpc-url ${DEV_RPC_URL} --broadcast --verify -vvvv

verify-mock-dn404:
	@echo "Verifying contract"
	forge verify-contract --etherscan-api-key ${ETHERSCAN_API_KEY} ${}  ./src/LoginCoin.sol:LoginCoin --chain 11155111
	forge verify-contract 

.PHONY: test