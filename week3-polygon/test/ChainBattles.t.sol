// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console2.sol";
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
        assertEq(chainBattlesContract.getLevel(_tokenId), "0");
        assertEq(chainBattlesContract.ownerOf(_tokenId), address(this));
    }

    function testTrain() public {
        assertEq(chainBattlesContract.getLevel(myTokenId), "0");
        chainBattlesContract.train(myTokenId);
        assertEq(chainBattlesContract.getLevel(myTokenId), "1");
        chainBattlesContract.train(myTokenId);
        assertEq(chainBattlesContract.getLevel(myTokenId), "2");
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

    function testGenerateCharacter() public view {
        string memory svg = chainBattlesContract.generateCharacter(myTokenId);
        console.logString(svg);
    }
}
