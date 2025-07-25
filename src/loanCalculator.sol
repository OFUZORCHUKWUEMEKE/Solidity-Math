// SPDX-License-Identifier: MIT
// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

contract LoanCalculator {
    function calculatePercentage(uit256 value , percentage) public pure returns (uint256 result) {
        uint256 public const BASIS_POINTS_DENOMINATOR = 10000; //100%

        uint256 private numerator = value * percentage;

        result = numerator / BASIS_POINTS_DENOMINATOR
    }
}
