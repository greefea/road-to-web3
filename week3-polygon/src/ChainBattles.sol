// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Strings for uint8;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    struct Stats {
        uint8 Level;
        uint8 Speed;
        uint8 Strength;
        uint8 Life;
    }
    mapping(uint256 => Stats) public tokenIdToLevels;

    constructor() ERC721("Chain Battles", "CBTLS") {}

    function generateCharacter(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">'
            "<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>"
            '<rect width="100%" height="100%" fill="black" />'
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">'
            "Warrior"
            "</text>"
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">'
            "Level: ",
            getLevel(tokenId),
            " | Speed: ",
            getSpeed(tokenId),
            " | Strength: ",
            getStrength(tokenId),
            " | Life: ",
            getLife(tokenId),
            "</text>"
            "</svg>"
        );
        return
            string(
                abi.encodePacked(
                    "data:image/svg+xml;base64,",
                    Base64.encode(svg)
                )
            );
    }

    function getLevel(uint256 tokenId) public view returns (string memory) {
        return tokenIdToLevels[tokenId].Level.toString();
    }

    function getSpeed(uint256 tokenId) public view returns (string memory) {
        return tokenIdToLevels[tokenId].Speed.toString();
    }

    function getStrength(uint256 tokenId) public view returns (string memory) {
        return tokenIdToLevels[tokenId].Strength.toString();
    }

    function getLife(uint256 tokenId) public view returns (string memory) {
        return tokenIdToLevels[tokenId].Life.toString();
    }

    function getTokenURI(uint256 tokenId) public view returns (string memory) {
        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "Chain Battles #',
            tokenId.toString(),
            '",',
            '"description": "Battles on chain",',
            '"image": "',
            generateCharacter(tokenId),
            '"',
            "}"
        );
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(dataURI)
                )
            );
    }

    function mint() public returns (uint256) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        uint8 maxInit = 32;
        tokenIdToLevels[newItemId] = Stats(
            0,
            random(maxInit, "speed"),
            random(maxInit, "strength"),
            random(maxInit, "life")
        );
        _setTokenURI(newItemId, getTokenURI(newItemId));

        return newItemId;
    }

    function train(uint256 _tokenId) public {
        require(_exists(_tokenId), "token doesn't exist");
        require(
            msg.sender == ownerOf(_tokenId),
            "Only token owner can call train"
        );
        uint8 maxInc = 4;
        Stats memory stats = tokenIdToLevels[_tokenId];
        tokenIdToLevels[_tokenId] = Stats(
            stats.Level + 1,
            stats.Speed + random(maxInc, "speed"),
            stats.Strength + random(maxInc, "strength"),
            stats.Life + random(maxInc, "life")
        );
    }

    function random(uint8 max, string memory salt) public view returns (uint8) {
        uint256 randn = uint256(
            keccak256(
                abi.encodePacked(
                    block.timestamp,
                    block.difficulty,
                    msg.sender,
                    salt
                )
            )
        ) % max;
        return uint8(randn);
    }
}
