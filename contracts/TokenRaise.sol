// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenRaise is Ownable {
    struct Raise {
        uint256 raiseAmount;
        uint256 fullFillAmount;
        address coin;
        uint256 startTime;
        uint256 endTime;
        bool isWithdraw;
    }

    mapping(address => Raise) public raises;

    constructor() Ownable(msg.sender) {}

    function raise(
        address _coin,
        uint256 _raiseAmount,
        uint256 _fees,
        uint256 _startTime,
        uint256 _endTime
    ) public returns (bool) {
        require(_coin != address(0), "Invalid coin adress");
        require(_raiseAmount > 0, "Raise amount should be greater than zero");
        require(_startTime > block.timestamp, "Invalid start time");
        require(
            _endTime > _startTime,
            "End time should be greater than start time"
        );

        raises[_msgSender()] = Raise(
            _raiseAmount,
            0,
            _coin,
            _startTime,
            _endTime,
            false
        );

        // User need to approve to contract before calling current function
        bool success = IERC20(_coin).transferFrom(_msgSender(), owner(), _fees);
        return success;
    }

    function withdraw() public returns (bool) {
        Raise storage currentRaise = raises[_msgSender()];

        require(
            raises[_msgSender()].endTime < block.timestamp,
            "Can not withdraw now, try later"
        );
        require(!currentRaise.isWithdraw, "Already withdraw");

        currentRaise.isWithdraw = true;
        // User need to approve to contract before calling current function
        bool success = IERC20(currentRaise.coin).transferFrom(
            owner(),
            _msgSender(),
            currentRaise.fullFillAmount
        );

        return success;
    }

    function invest(uint256 _amount) public returns (bool) {
        require(_amount > 0, "Amount must be greater than zero");

        uint256 amountToBeAdded = raises[_msgSender()].fullFillAmount + _amount;

        require(amountToBeAdded > 0, "Raised amount is already satisfied");

        raises[_msgSender()].fullFillAmount = amountToBeAdded;
        // User need to approve to contract before calling current function
        bool success = IERC20(raises[_msgSender()].coin).transferFrom(
            _msgSender(),
            address(this),
            _amount
        );

        return success;
    }
}
