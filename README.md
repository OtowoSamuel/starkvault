# 🔐 StarkVault

**StarkVault** is a simple smart contract written in Cairo for the Starknet ecosystem. It securely stores a secret behind a password, allows password resets, and tracks how many times a user has accessed the secret.

---

## ✨ Features

- 🔑 Store a secret with a password
- 🔍 Retrieve the secret using the correct password
- 🔁 Reset your password securely
- 📊 Track how many times the secret has been accessed

---

## 🧠 Contract Interface

```cairo
fn set_secret(secret: felt252, password: felt252);
fn get_secret(password: felt252) -> felt252;
fn reset_password(old_password: felt252, new_password: felt252);
fn get_access_count() -> felt252;
