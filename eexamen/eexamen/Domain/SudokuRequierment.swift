//
//  SudokuRequierment.swift
//  eexamen
//
//  Created by user285809 on 11/27/25.
//

import Foundation

protocol SudokuRequirementProtocol {
    func generatePuzzle(size: Int, difficulty: String) async -> SudokuBoard?
    func verifySolution(board: SudokuBoard) -> Bool
    func saveGame(board: SudokuBoard)
    func loadSavedGame() -> SudokuBoard?
    func deleteSavedGame()
    func hasSavedGame() -> Bool
}

class SudokuRequirement: SudokuRequirementProtocol {
    static let shared = SudokuRequirement()
    
    let repo: SudokuRepository
    
    init(repo: SudokuRepository = SudokuRepository.shared) {
        self.repo = repo
    }
    
    func generatePuzzle(size: Int, difficulty: String) async -> SudokuBoard? {
        await repo.generatePuzzle(size: size, difficulty: difficulty)
    }
    
    func verifySolution(board: SudokuBoard) -> Bool {
        // Verificar que todas las celdas estén llenas
        for row in board.cells {
            for cell in row {
                if cell.currentValue == nil {
                    return false
                }
            }
        }
        
        // Comparar con la solución
        for row in 0..<board.cells.count {
            for col in 0..<board.cells[row].count {
                let currentValue = board.cells[row][col].currentValue ?? 0
                let solutionValue = board.solution[row][col]
                
                if currentValue != solutionValue {
                    return false
                }
            }
        }
        
        return true
    }
    
    func saveGame(board: SudokuBoard) {
        repo.saveGame(board: board)
    }
    
    func loadSavedGame() -> SudokuBoard? {
        repo.loadSavedGame()
    }
    
    func deleteSavedGame() {
        repo.deleteSavedGame()
    }
    
    func hasSavedGame() -> Bool {
        repo.hasSavedGame()
    }
}
