## Preamble

    Title: Gluwacoin Standard
    Author: Tae Lim Oh <taelim.oh@gluwa.com>
    Type: Standard
    Created: 2022-05-16


## Simple Summary

A standard interface for interoperable tokens.


## Abstract

The following standard allows for the implementation of a standard API for interoperable tokens 
compliant with the ERC20 token standard. 
This standard provides every standard ERC20 token method and, additionally, six custom methods for circulation control, 
ETHless transfer, and non-custodial exchange.


## Motivation

A standard interface to add any ERC-20 token to the Gluwa ecosystem to be re-used by other applications: 
from ETHless transfer and non-custodial exchange.


## Specification

## Token
### Methods

**NOTE**: Callers MUST handle `false` from `returns (bool success)`.
Callers MUST NOT assume that `false` is never returned!

#### Gluwacoin Methods



##### mint

Creates `amount` tokens to the caller.

``` js
function mint(uint256 amount)
```



##### burn

Destroys `amount` tokens from the caller.

``` js
function burn(uint256 amount)
```


**Etherless Transfer Functions**

Gluwacoin standard supports Etherless transfer for Gluwacoin users.
Instead of paying gas to transfer Gluwacoin, a user pays a transfer fee in Gluwacoin to the contract owner.



##### transfer

A standard ERC20 function but with `_fee`, `_nonce`, and `_sig` as extra parameters.
`_fee` is a transfer fee amount in Gluwacoin, which the sender will pay for the transaction.
`_sig` is a signature created by signing the transfer information with the sender’s private key.
Anyone can initiate the transfer for the sender by calling the Etherless Transfer function 
with the transfer information and the signature. 
The caller will have to pay the gas for calling the function.

Transfers `_value` amount of tokens to address `_to`, and MUST fire the `Transfer` event.
The function SHOULD `throw` if the `_from` account balance does not have enough tokens to spend.

*Note* Transfers of 0 values MUST be treated as normal transfers and fire the `Transfer` event.

``` js
function transfer(address _from, address _to, uint256 _value, uint256 _fee, uint256 _nonce, bytes memory _sig) public returns (bool success)
```

**Non-custodial Exchange Function**

Gluwacoin supports functions for non-custodial exchange use cases. Instead of trusting a 3rd party to hold Gluwacoins for an exchange, a user can request the 3rd party to lock Gluwacoins at the user’s account instead. The locked Gluwacoins are called a reserve and can only be released to the pre-designated receiver or unlocked back to the sender.
Note that the exchange can happen not only between Gluwacoins but also with other cryptocurrencies. If a cryptocurrency supports features equivalent to the Gluwacoin non-custodial exchange functions, it is compatible. For instance, Bitcoin is compatible with Gluwacoin non-custodial exchange when utilizing a 2-to-3 multi-sig wallet.



##### reserve

Creates a reserve in `_from` address. 
The amount of the reserve is `_amount` and each reserve has `_nonce`  which is unique together with `_from`.
Assigns receiver's address `_to` and the validator's address `_executor`.
`_expiryBlockNum` specifies when the `_from` address can reclaim the reserve in case the reserve is unused.
`_sig` is a signature created by signing the transfer information with the `_from` address' private key.

``` js
function reserve(address _from, address _to, address _executor, uint256 _amount, uint256 _fee, uint256 _nonce, uint256 _expiryBlockNum, bytes memory _sig) public returns (bool success)
```



##### execute

Releases a fund reserved in `_sender` address. 
The reserve is specified by `_nonce`. 
The released fund is transferred to `_to` address. 
Reserved for the `_executor`. 

**Note** `_to` and `_executor` are pre-determined when the reserve was created.

``` js 
function execute(address _sender, uint256 _nonce) public returns (bool success)
```



##### reclaim

Returns a fund reserved in `_sender` address. 
The reserve is specified by `_nonce`. 
The fund is transferred to `_from` address. 
Reserved for the `_from`  and `_executor`. 
While `_executor` can call the function any time, `_from` can only call after `_expiryBlockNum`. 

**Note** `_from`, `_executor`, and `_expiryBlockNum` are pre-determined when the reserve was created.

``` js
function reclaim(address _sender, uint256 _nonce) public returns (bool success)
```



#### ERC-20 Methods

##### name

Returns the name of the token - e.g. `"MyToken"`.

OPTIONAL - This method can be used to improve usability,
but interfaces and other contracts MUST NOT expect these values to be present.


``` js
function name() constant returns (string name)
```


##### symbol

Returns the symbol of the token. E.g. "HIX".

OPTIONAL - This method can be used to improve usability,
but interfaces and other contracts MUST NOT expect these values to be present.

``` js
function symbol() constant returns (string symbol)
```



##### decimals

Returns the number of decimals the token uses - e.g. `8`, means to divide the token amount by `100000000` to get its user representation.

OPTIONAL - This method can be used to improve usability,
but interfaces and other contracts MUST NOT expect these values to be present.

``` js
function decimals() constant returns (uint8 decimals)
```


##### totalSupply

Returns the total token supply.

``` js
function totalSupply() constant returns (uint256 totalSupply)
```



##### balanceOf

Returns the account balance of another account with address `_owner`.

``` js
function balanceOf(address _owner) constant returns (uint256 balance)
```



##### transfer

Transfers `_value` amount of tokens to address `_to`, and MUST fire the `Transfer` event.
The function SHOULD `throw` if the `_from` account balance does not have enough tokens to spend.

*Note* Transfers of 0 values MUST be treated as normal transfers and fire the `Transfer` event.

``` js
function transfer(address _to, uint256 _value) returns (bool success)
```



##### transferFrom

Transfers `_value` amount of tokens from address `_from` to address `_to`, and MUST fire the `Transfer` event.

The `transferFrom` method is used for a withdraw workflow, allowing contracts to transfer tokens on your behalf.
This can be used for example to allow a contract to transfer tokens on your behalf and/or to charge fees in sub-currencies.
The function SHOULD `throw` unless the `_from` account has deliberately authorized the sender of the message via some mechanism.

*Note* Transfers of 0 values MUST be treated as normal transfers and fire the `Transfer` event.

``` js
function transferFrom(address _from, address _to, uint256 _value) returns (bool success)
```



##### approve

Allows `_spender` to withdraw from your account multiple times, up to the `_value` amount. If this function is called again it overwrites the current allowance with `_value`.

**NOTE**: To prevent attack vectors like the one [described here](https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/) and discussed [here](https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729),
clients SHOULD make sure to create user interfaces in such a way that they set the allowance first to `0` before setting it to another value for the same spender.
THOUGH The contract itself shouldn't enforce it, to allow backwards compatibility with contracts deployed before

``` js
function approve(address _spender, uint256 _value) returns (bool success)
```


##### allowance

Returns the amount which `_spender` is still allowed to withdraw from `_owner`.

``` js
function allowance(address _owner, address _spender) constant returns (uint256 remaining)
```



### Events

#### Gluwacoin Events

##### Mint

MUST trigger on any successful call to `mint(address _to, uint256 _value)`.

```
event Mint(address indexed _mintTo, uint256 _value)
```

##### Burnt

MUST trigger on any successful call to `burn(address _to, uint256 _value)`.

``` js
event Burnt(uint256 _value)
```

#### ERC-20 Events

##### Transfer

MUST trigger when tokens are transferred, including zero value transfers.

A token contract which creates new tokens SHOULD trigger a Transfer event with the `_from` address set to `0x0` when tokens are created.

``` js
event Transfer(address indexed _from, address indexed _to, uint256 _value)
```



##### Approval

MUST trigger on any successful call to `approve(address _spender, uint256 _value)`.

``` js
event Approval(address indexed _owner, address indexed _spender, uint256 _value)
```



## Implementation

Gluwa provides standard implementations of Gluwacoin.
You can implement it differently to have different trade-offs: from gas saving to improved security.

#### Example implementations are available at
- Wrapped Gluwacoin implementation from Gluwa, Inc.: https://github.com/gluwa/ERC-20-Wrapper-Gluwacoin
- Controlled Gluwacoin implementation from Gluwa, Inc.: https://github.com/gluwa/Controlled-Gluwacoin


## History

Historical links related to this standard:

### ERC-20
- Orginial proposal from Vitalik Buterin: https://github.com/ethereum/wiki/wiki/Standardized_Contract_APIs/499c882f3ec123537fc2fccd57eaa29e6032fe4a
- Reddit discussion: https://www.reddit.com/r/ethereum/comments/3n8fkn/lets_talk_about_the_coin_standard/
- Original Issue #20: https://github.com/ethereum/EIPs/issues/20

## Copyright
Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
