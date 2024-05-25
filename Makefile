include .env

test: ## Run tests 
	@echo "Running tests"
	forge test --gas-report -vv

deploy-mock-dn404:
	@echo "Deploying contract"
	forge script script/mocks/DeploySimpleDN404.s.sol:SimpleDN404Script --rpc-url ${DEV_RPC_URL} --broadcast --verify -vvvv

.PHONY: test