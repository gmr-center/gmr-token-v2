//
// _____/\\\\\\\\\\\\_____/\\\\\\\\\_____/\\\\____________/\\\\__/\\\\\\\\\\\\\\\____/\\\\\\\\\________________________________/\\\\\\\\\_____        
//  ___/\\\//////////____/\\\\\\\\\\\\\__\/\\\\\\________/\\\\\\_\/\\\///////////___/\\\///////\\\____________________________/\\\///////\\\___       
//   __/\\\______________/\\\/////////\\\_\/\\\//\\\____/\\\//\\\_\/\\\_____________\/\\\_____\/\\\___________________________\///______\//\\\__      
//    _\/\\\____/\\\\\\\_\/\\\_______\/\\\_\/\\\\///\\\/\\\/_\/\\\_\/\\\\\\\\\\\_____\/\\\\\\\\\\\/_______________/\\\____/\\\___________/\\\/___     
//     _\/\\\___\/////\\\_\/\\\\\\\\\\\\\\\_\/\\\__\///\\\/___\/\\\_\/\\\///////______\/\\\//////\\\______________\//\\\__/\\\_________/\\\//_____    
//      _\/\\\_______\/\\\_\/\\\/////////\\\_\/\\\____\///_____\/\\\_\/\\\_____________\/\\\____\//\\\______________\//\\\/\\\_______/\\\//________   
//       _\/\\\_______\/\\\_\/\\\_______\/\\\_\/\\\_____________\/\\\_\/\\\_____________\/\\\_____\//\\\______________\//\\\\\______/\\\/___________  
//        _\//\\\\\\\\\\\\/__\/\\\_______\/\\\_\/\\\_____________\/\\\_\/\\\\\\\\\\\\\\\_\/\\\______\//\\\______________\//\\\______/\\\\\\\\\\\\\\\_ 
//         __\////////////____\///________\///__\///______________\///__\///////////////__\///________\///________________\///______\///////////////__
//

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
pragma abicoder v2; // required to accept structs as function parameters

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

/////////////////////////////////////////////////////////////////////////
// Minting schedule interface
/////////////////////////////////////////////////////////////////////////
/// @notice Interface method to get able to mint
interface IMintingSchedule {
  function ableToMint(uint256 amount) external view returns(bool);
}

contract GMRTokenV2 is ERC20, ERC20Burnable, Ownable
{

    address private _mintingSchedule;
    /////////////////////////////////////////////////////////////////////////
    // Constructor
    /////////////////////////////////////////////////////////////////////////
    constructor(
      string memory name,
      string memory symbol
    )
        ERC20(name, symbol)
    {
        _mint(msg.sender, 345000000 ether);
    }

    // Sink
    fallback() external payable {
      revert("Transaction not supported");
    }

    function setMintingSchedule(address newMintingSchedule) external onlyOwner {
      _mintingSchedule = newMintingSchedule;
    }

    function getMintingSchedule() external view returns(address) {
      return _mintingSchedule;
    }

    function mintFromSchedule(uint256 amount) external onlyOwner returns(bool){
      bool success = IMintingSchedule(_mintingSchedule).ableToMint(amount);
      if(success){
        _mint(owner(), amount);
        return true;
      }
      else{
        return false;
      }
    }

}
