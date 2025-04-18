/// Interface representing `HelloContract`.
/// This interface allows modification and retrieval of the contract balance.
#[starknet::interface]
pub trait IStarkVault<TContractState> {
    fn set_secret(ref self: TContractState, secret: felt252, password: felt252);
    fn get_secret(ref self: TContractState, password: felt252) -> felt252;
    fn reset_password(ref self: TContractState, old_password: felt252, new_password: felt252);
    fn get_access_count(self: @TContractState) -> felt252;
}
