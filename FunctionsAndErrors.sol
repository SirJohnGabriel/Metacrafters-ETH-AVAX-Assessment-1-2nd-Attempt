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
