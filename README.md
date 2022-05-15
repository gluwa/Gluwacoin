# Gluwacoin

Interoperable Token Standard

## What is Gluwacoin?

Gluwacoin is a cryptographic token standard.
It extends the ERC20 standard for tokens and adds functions for cross-blockchain exchanges.
The issuer can create Gluwacoin by different types of minting mechanisms such as wrapping, locking, or pegging
and by pegging it to a different underlying asset.
For example, you can wrap USD Coin into a Gluwacoin.
Further, Gluwacoin supports its users to pay network fees in the token, not the cryptocurrency of the network.

Originally proposed by the Gluwacoin Trust as a stablecoin standard,
Gluwa, Inc. currently maintains Gluwacoin as a general token standard focusing on interoperability.

For more information, see [Standard](/Standard.md).

### Code Examples

Gluwa currently maintain 3 main type of Gluwacoin contracts:
* [Wrapped Gluwacoin](https://github.com/gluwa/ERC-20-Wrapper-Gluwacoin): Gluwacoin wrapping another ERC-20 Token
* [Controlled Gluwacoin](https://github.com/gluwa/Controlled-Gluwacoin): Gluwacoin with a circulation supply controller