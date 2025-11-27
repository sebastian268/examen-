//
//  SudokuRepository.swift
//  eexamen
//
//  Created by user285809 on 11/27/25.
//

import Foundation

protocol SudokuRepositoryProtocol {
    func generatePuzzle(size: Int, difficulty: String) async -> SudokuBoard?
    func saveGame(board: SudokuBoard)
    func loadSavedGame() -> SudokuBoard?
    func deleteSavedGame()
    func hasSavedGame() -> Bool
}

class SudokuRepository: SudokuRepositoryProtocol {
    static let shared = SudokuRepository()
    
    let localService: LocalService
    
    init(localService: LocalService = LocalService.shared) {
        self.localService = localService
    }
    
    func generatePuzzle(size: Int, difficulty: String) async -> SudokuBoard? {
        // Cargar desde JSON local
        guard let puzzle = localService.loadLocalPuzzle() else {
            return nil
        }
        
        // Crear el tablero con la configuración solicitada
        let board = SudokuBoard(
            puzzle: puzzle.puzzle,
            solution: puzzle.solution,
            size: size,
            difficulty: difficulty
        )
        
        return board
    }
    
    func saveGame(board: SudokuBoard) {
        localService.saveGame(board: board)
    }
    
    func loadSavedGame() -> SudokuBoard? {
        localService.loadSavedGame()
    }
    
    func deleteSavedGame() {
        localService.deleteSavedGame()
    }
    
    func hasSavedGame() -> Bool {
        localService.hasSavedGame()
    }
}
