pub mod interfaces;
/// Simple contract for storing secrets.
#[starknet::contract]
mod StarkVault {
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    use crate::interfaces::IStarkVault;

    #[storage]
    struct Storage {
        secret: felt252,
        password_hash: felt252,
        access_count: felt252,
    }

    #[abi(embed_v0)]
    impl StarkVaultImpl of super::interfaces::IStarkVault<ContractState> {
        fn set_secret(ref self: ContractState, secret: felt252, password: felt252) {
            let password_hash = password;
            self.secret.write(secret);
            self.password_hash.write(password_hash);
            self.access_count.write(0);
        }

        fn get_secret(ref self: ContractState, password: felt252) -> felt252 {
            let stored_password_hash = self.password_hash.read();
            assert(password == stored_password_hash, 'Invalid Password');

            let current_count = self.access_count.read();
            self.access_count.write(current_count + 1_felt252);

            self.secret.read()
        }

        fn reset_password(ref self: ContractState, old_password: felt252, new_password: felt252) {
            let stored_password_hash = self.password_hash.read();
            assert(old_password == stored_password_hash, 'Invalid Password');
            self.password_hash.write(new_password);
        }
        fn get_access_count(self: @ContractState) -> felt252 {
            let current_count = self.access_count.read();
            current_count
        }
    }
}
