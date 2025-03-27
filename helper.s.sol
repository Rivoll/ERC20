    /*
    cast send 0x5FbDB2315678afecb367f032d93F642f64180aa3 --rpc-url http://127.0.0.1:8545 \
 "approve(address, uint256)" "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" "1000" \
 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

    cast send 0x5FbDB2315678afecb367f032d93F642f64180aa3 --rpc-url http://127.0.0.1:8545 \
    "transferFrom(address, address, uint256)" "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" \
    "0xa0Ee7A142d267C1f36714E4a8F75612F20a79720" "100" \
    --private-key 0x5de4111afa1a4b94908f83103eb1f1706367c2e68ca870fc3fb9a804cdab365a

    cast call 0x5FbDB2315678afecb367f032d93F642f64180aa3 --rpc-url http://127.0.0.1:8545 \
    "balanceOf(address)" 0xa0Ee7A142d267C1f36714E4a8F75612F20a79720
    */