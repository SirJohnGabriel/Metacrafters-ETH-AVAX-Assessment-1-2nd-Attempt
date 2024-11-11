# FunctionsAndErrors - A Metacrafters Project for ETH + AVAX Proof

This project is a simple Tic-Tac-Toe game contract that demonstrates the use of `require()`, `assert()`, and `revert()` statements.

## Description

The project simulates a two-player Tic-Tac-Toe game on the Ethereum blockchain. It allows two players to join a game, take turns to make moves on a 3x3 board, and determines a winner or if the game is a draw. The contract includes checks to ensure that players take turns and that only available board positions can be chosen.

## Getting Started

### Installing

1. Install [Node.js](https://nodejs.org)

   Download and install from the official site.

2. Install [Truffle](https://github.com/trufflesuite/truffle)

   ```bash
   npm install -g truffle
   ```

### Executing Program

To run this program, use the Gitpod tools provided by Metacrafters.

## Initialize

1. Initialize Truffle in your project folder:

   ```bash
   truffle init
   ```

   After initialization, you will find two folders: `contracts` for your Solidity files and `migrations` for deployment settings.

2. The "FunctionsAndErrors" contract

   "FunctionsAndErrors.sol" in `contracts` contains the following code:

   ```solidity
   // SPDX-License-Identifier: MIT
   pragma solidity ^0.8.18;

   contract FunctionsAndErrors {
       address public firstPlayer;
       address public secondPlayer;
       address public currentPlayer;
       uint8[9] public board;
       bool public gameActive;
       address public winner;

       modifier currentPlayerOnly() {
           require(msg.sender == currentPlayer, "Not your turn yet.");
           _;
       }

       modifier gameIsActive() {
           require(firstPlayer != address(0) && secondPlayer != address(0), "Game not full.");
           require(gameActive, "Game is not active");
           _;
       }

       function joinGame() external {
           if (firstPlayer == address(0)) {
               firstPlayer = msg.sender;
               currentPlayer = firstPlayer;
           } else if (secondPlayer == address(0)) {
               secondPlayer = msg.sender;
               gameActive = true;
           } else {
               revert("Game already has two players");
           }
       }

       function makeMove(uint8 pos) external currentPlayerOnly gameIsActive {
           require(pos < 9, "Position out of bounds");
           require(board[pos] == 0, "Position already taken");

           board[pos] = (msg.sender == firstPlayer) ? 1 : 2;

           if (checkWinner()) {
               gameActive = false;
               winner = currentPlayer;
           } else if (isBoardFull()) {
               gameActive = false;
           } else {
               address previousPlayer = currentPlayer;
               currentPlayer = (currentPlayer == firstPlayer) ? secondPlayer : firstPlayer;

               assert(currentPlayer != previousPlayer);
           }
       }

       function isBoardFull() internal view returns (bool) {
           for (uint8 i = 0; i < 9; i++) {
               if (board[i] == 0) return false;
           }
           return true;
       }

       function checkWinner() internal view returns (bool) {
           uint8[3][8] memory winningPositions = [
               [0, 1, 2], [3, 4, 5], [6, 7, 8],
               [0, 3, 6], [1, 4, 7], [2, 5, 8],
               [0, 4, 8], [2, 4, 6]
           ];

           uint8 playerSymbol = (msg.sender == firstPlayer) ? 1 : 2;
           for (uint8 i = 0; i < 8; i++) {
               if (
                   board[winningPositions[i][0]] == playerSymbol &&
                   board[winningPositions[i][1]] == playerSymbol &&
                   board[winningPositions[i][2]] == playerSymbol
               ) {
                   return true;
               }
           }
           return false;
       }
   }
   ```

3. Prepare the Migration

   Create "2_deploy_functions_and_errors.js" in `migrations` with the following code:

   ```javascript
   const FunctionsAndErrors = artifacts.require("FunctionsAndErrors");

   module.exports = function (deployer) {
     deployer.deploy(FunctionsAndErrors);
   };
   ```

4. Start Truffle Console in Development Mode

   ```bash
   truffle develop
   ```

   In the Truffle console, execute:

   ```bash
   compile
   migrate
   ```

   To remigrate existing contracts, use `migrate --reset` instead of simply `migrate`.

## Authors

John Gabriel T. Pagtlaunan  
@202120016@fit.edu.ph  
@j.g.pagtalunan14@gmail.com

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
