module my_first_package::move_nft;

use std::string::String;
use sui::event;
use sui::url::{Self, Url};

/// An example NFT that can be minted by anybody
public struct MoveNFT has key, store {
    id: UID,
    name: String,
    description: String,
    url: Url,
}

/// Event emitted when an NFT is minted
public struct NFTMinted has copy, drop {
    object_id: ID,
    creator: address,
    name: String,
}

/// Create a new NFT and transfer it to the sender
public entry fun mint_nft(
    name: vector<u8>,
    description: vector<u8>,
    url: vector<u8>,
    ctx: &mut TxContext,
) {
    let nft = MoveNFT {
        id: object::new(ctx),
        name: name.to_string(),
        description: description.to_string(),
        url: url::new_unsafe_from_bytes(url),
    };

    event::emit(NFTMinted {
        object_id: nft.id.to_inner(),
        creator: ctx.sender(),
        name: nft.name,
    });

    transfer::transfer(nft, ctx.sender());
}

/// Get the NFT's name
public fun name(nft: &MoveNFT): String { nft.name }

/// Get the NFT's description
public fun description(nft: &MoveNFT): String { nft.description }

/// Get the NFT's url
public fun url(nft: &MoveNFT): Url { nft.url }