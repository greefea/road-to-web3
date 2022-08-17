// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/ChainBattles.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";

contract ChainBattlesTest is Test, ERC721Holder {
    ChainBattles public chainBattlesContract;
    uint256 myTokenId;

    function setUp() public {
        chainBattlesContract = new ChainBattles();
        myTokenId = chainBattlesContract.mint();
    }

    function testMint() public {
        uint256 _tokenId = chainBattlesContract.mint();
        assertTrue(chainBattlesContract.tokenIdToLevels(_tokenId) == 0);
        assertEq(chainBattlesContract.ownerOf(_tokenId), address(this));
    }

    function testTrain() public {
        chainBattlesContract.train(myTokenId);
        assertTrue(chainBattlesContract.tokenIdToLevels(myTokenId) == 1);
        chainBattlesContract.train(myTokenId);
        assertTrue(chainBattlesContract.tokenIdToLevels(myTokenId) == 2);
    }

    function testTrainRevert(uint256 _tokenId) public {
        if (_tokenId != myTokenId) {
            vm.expectRevert(bytes("token doesn't exist"));
            chainBattlesContract.train(_tokenId);
        }
    }

    function testFailTrainNotOwner() public {
        vm.prank(address(0));
        chainBattlesContract.train(myTokenId);
    }
}
