// SPDX-License-Identifier: MIT

/**
 * @title Percentage Calculations in Defi - Deep Dive
 * @dev Understanding basis points and percentage math in Solidity
 */

contract PercentageExplained{
    //  ==============================
    //  UNDERSTANDING BASIS POINTS
    // ===============================

    /**
     * BASIS POINTS EXPLANATION
     * Basis points (bps) are a unit of measurement used in finance.
     * 1. basis point = 0.01% = 1/10000
     * Examples:
     * - 1 bps = 0.01%
     * - 100 bps = 1%
     * - 500 bps = 5%
     * - 10000 bps = 100%
     * 
     * Why use basis points instead of Percentages ?
     * 1. Precision: Avoids decimals in Solidity (no native decimal support)
     * 2. Standardization: Common in traditional finance
     * 3. Gas efficiency: Integer math is cheaper than decimals approximations
     */
    uint256 public constant BASIS_POINTS_DENOMINATOR = 10000; //100%
    uint256 public constant ONE_PERCENT = 100; //1%
    uint256 public constant HALF_PERCENT = 50; //0.5%
    uint256 public constant QUARTER_PERCENT = 25; //0.25%

    // =======================================
    // THE BASIC PERCENTAGE FUNCTION EXPLAINED
    // =======================================


    /**
     * @dev Calculate percentage of a value using basis points 
     * @param value The base value (e.g , 1000 Tokens)
     * @param percentage Pecentage in basis points (e.g. , 0)
     * @return result The calculated percentage amount
     */
    function calculatePercentage(uint256 value, uint256 percentage) public pure returns(uint 256){
        // Formula:(value x percentage) % 10000
        // Example: (1000 x 500) % 10000 = 500000 % 10000 = 50
        result = (value * percentage) / BASIS_POINTS_DENOMINATOR;

        return result;
    }

    // ========================================
    // STEP-BY-STEP BREAKDOWN WITH EXAMPLES
    // ========================================

    /**
     * @dev Detailed breakdown of the calculations with logging
     */
    function calculatePercentageWithSteps(uint256 value, uint256 percentage) public pure returns(
        uint256 step_multiplication,
        uint256 step2_division,
        uint256 final_result
    ){
        // Step 1: Multiply value by percentage (in basis points)
        step_multiplication = value * percentage;

        // Step 2: Divide by 10000 to convert from basis points to actual amount
        step2_division = step1_multiplication / BASIS_POINTS_DENIMINATOR;

        final_result = step2_division;

        return (step1_multiplication , step2_division , final_result);

    }

    // ========================================
    // PRACTICAL EXAMPLES IN DEFI
    // ========================================
    /**
     * @dev Example 1 : Calculate trading fee
     * If you trade 1000 USDC with a 0.3% fee (30 basis points)
     */
    function calculateTradingFee() public pure returns(uint256 fee){
        uint256 tradeAmount = 1000 * 1e6; // 1000 USDC (6 Decimals)
        uint256 feeRate = 30; //0.3% in basis points

        fee = calculatePercentage(tradeAmount,feeRate);
        // Result: 3 * 1e6 = 3 USDC
        return fee;
    }

    /**
     * @dev Example 2: Calculate loan interest
     * Borrow 5000 DAI at 8% annual rate (800 basis points)
     */
    function calculateAnnualInterest() public pure returns (uint256 interest){
        uint256 loanAmount = 5000 * 1e18; //5000 DAI (18 decimals)
        uint256 annualRate = 800; // 8% in basia points

        interest = calculatePercentage(loanAmount , annualRate);
        // Result: 400 * 1e18 = 400 DAI per year

        return interest;
    }

    /**
     * @dev Example 3: Calculate liquidation penalty
     * Liquidate position worth 2000 USDC with 5% penalty (500 basis points)
     */
    function calculateLiquidationPenalty() public pure returns (uint256 penalty) {
        uint256 positionValue = 2000 * 1e6; // 2000 USDC
        uint256 penaltyRate = 500; // 5% in basis points
        
        penalty = calculatePercentage(positionValue, penaltyRate);
        // Result: 100 * 1e6 = 100 USDC penalty
        
        return penalty;
    }

    / ========================================
    // COMMON PITFALLS AND SOLUTIONS
    // ========================================
    
    /**
     * @dev PITFALL 1 : Integer Division truncation
     * When the result has decimals , Solidity truncates (rounds down)
    */
   function demostrateTruncation() public pure returns(uint256 , uint256){
    // Example: 1% of 99 tokens
    uint256 amount = 99;
    uint256 onePercent = 100; //1%

    uint256 result = calculatePercentage(amount,onePercent);
    // Mathematical result: 99 * 100 / 10000 = 0.99
    // Solidity result: 0 (truncated)


    // Better approach: Check if calculation makes sense
    uint256 minimumAmount = BASIS_POINTS_DENOMINATOR / onePercent;
    // For 1% minimum amount is 10000/100 = 100

    return (result , minimumAmount);

   }

   /**
    * @dev SOLUTION: Add precision for small percentages
    */
   function calculatePercentageWithPrecision(
    uint256 value,
    uint256 percentage,
    uint256 precision
   )public pure returns(uint256){
    // Multiply by precision factor before division
    return (value  * percentage * precision) / BASIS_POINTS_DENOMINATOR / precision
   }

    /**
     * @dev PITFALL 2: Order of operations matters
     * Always multiply before dividing to maintain precision
     */
    function demonstrateOrderOfOperations() public pure returns(uint256 correct,uint256 wrong){
        uint256 value = 1500;
        uint256 percentage = 250; //2.5%

        // CORRECT: MULTIPLY first , then divide
        correct = (value * percentage) / BASIS_POINTS_DENOMINATOR;
        // = (1500 * 250) / 10000 = 375000 / 10000 = 37

        // Wrong: Divide first (Don't do this)
        // This would cause precision loss or even division by zero wrong = (value / BASIS_POINTS_DENOMINATOR) * percentage;
        // = (1500 / 10000) * 250 = 0 * 250 = 0
        // For demostration , lets use a safe wrong calculation 
        wrong = 0; //This Represents the incorrect result
        return (correct , wrong);
    }

    // ========================================
    // ADVANCED PERCENTAGE CALCULATIONS
    // ========================================
    /**
     * @dev Calculate what percentage one value is of another
     * Example: What percentage is 75 of 300?
     */
    function calculateWhatPercentage(uint256 part, uint256 whole) public pure returns(uint256 percentage){
        require(whole > 0, "Division by zero");
        // Formula:(part * 10000) / whole
        percentage  = (part * BASIS_POINTS_DENOMINATOR) / whole;
        // Example: (75 * 10000) / 300 = 750000 / 300 = 2500 basis points = 25%

        return percentage;
    }

    /**
     * @dev Calculate compound percentage increases
     * Example: Apply 5% increase twice
     */
    function calculateCompoundPercentage(
        uint256 value,
        uint256 percentage,
        uint256 times
    )public pure returns(uint256 result){
        result = value;

        for(uint256 i=0; i<times; i++){
            uint256 increase = calculatePercentage(result,percentage);
            result = result + increase;
        }

        return result;
    }

     
    /**
     * @dev Calculate percentage difference between two values
     */
    function calculatePercentageDiff(uint256 value1, uint256 value2) public pure returns(uint256 percentageChange, bool isIncrease) {
        if(value1 >= value2){
            uint256 increase = value1 - value2;
            percentageChange = calculateWhatPercentage(increase,value2);
            isIncrease= true;
        }else{
            uint256 decrease = value2 - value1;
            percentageChange = calculateWhatPercentage(decrease,value2);
            isIncrease = false;
        }
        return (percentageChange,isIncrease);

    }

}