use snforge_std::{ContractClassTrait, DeclareResultTrait, declare};
use starknet::ContractAddress;

// use starkvault::interfaces::IStarkVaultSafeDispatcher;
// use starkvault::interfaces::IStarkVaultSafeDispatcherTrait;
use starkvault::interfaces::IStarkVaultDispatcher;
use starkvault::interfaces::IStarkVaultDispatcherTrait;

fn deploy_contract(name: ByteArray) -> ContractAddress {
    let contract = declare(name).unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@ArrayTrait::new()).unwrap();
    contract_address
}

#[test]
fn test_set_and_get_secret() {
    let contract_address = deploy_contract("StarkVault");

    let dispatcher = IStarkVaultDispatcher { contract_address };

    let secret_to_store = 12345;
    let password_to_store = 67890;

    dispatcher.set_secret(secret_to_store, password_to_store);

    let retrieved_secret = dispatcher.get_secret(password_to_store);

    assert(retrieved_secret == secret_to_store, 'Invalid secret');
}

#[test]
#[should_panic]
fn test_get_secret_with_wrong_password() {
    let contract_address = deploy_contract("StarkVault");

    let dispatcher = IStarkVaultDispatcher { contract_address };

    let secret_to_store = 12345;
    let password_to_store = 67890;

    dispatcher.set_secret(secret_to_store, password_to_store);

    let wrong_password = 11111;

    dispatcher.get_secret(wrong_password);
}

#[test]
fn test_reset_password() {
    let contract_address = deploy_contract("StarkVault");

    let dispatcher = IStarkVaultDispatcher { contract_address };

    let secret_to_store = 12345;
    let password_to_store = 67890;

    dispatcher.set_secret(secret_to_store, password_to_store);

    let new_password = 54321;

    dispatcher.reset_password(password_to_store, new_password);
    assert!(dispatcher.get_secret(new_password) == secret_to_store, "Invalid secret");
}

#[test]
fn test_get_access_count() {
    let contract_address = deploy_contract("StarkVault");

    let dispatcher = IStarkVaultDispatcher { contract_address };

    let secret_to_store = 12345;
    let password_to_store = 67890;

    dispatcher.set_secret(secret_to_store, password_to_store);
    dispatcher.get_secret(password_to_store);
    dispatcher.get_secret(password_to_store);
    dispatcher.get_secret(password_to_store);
    dispatcher.get_secret(password_to_store);

    let access_count = dispatcher.get_access_count();
    assert(access_count == 4, 'Invalid count')
}

