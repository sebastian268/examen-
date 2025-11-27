//
//  GameViewModel.swift
//  eexamen
//
//  Created by user285809 on 11/27/25.
//

import Foundation
import Combine

class GameViewModel: ObservableObject {
    @Published var board: SudokuBoard?
    @Published var selectedCell: (row: Int, col: Int)?
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var gameCompleted = false
    
    var requirement: SudokuRequirementProtocol
    
    init(requirement: SudokuRequirementProtocol = SudokuRequirement.shared) {
        self.requirement = requirement
    }
    
    @MainActor
    func loadNewGame(size: Int, difficulty: String) async {
        isLoading = true
        
        let newBoard = await requirement.generatePuzzle(size: size, difficulty: difficulty)
        
        if let newBoard = newBoard {
            self.board = newBoard
            alertTitle = "Nuevo Juego"
            alertMessage = "Puzzle de \(size)x\(size) cargado. Nivel: \(difficultyName(difficulty))"
            showAlert = true
        } else {
            alertTitle = "Error"
            alertMessage = "No se pudo cargar el puzzle. Verifica que el archivo sudoku_puzzle.json esté en el bundle."
            showAlert = true
        }
        
        isLoading = false
    }
    
    @MainActor
    func loadSavedGame() {
        if let savedBoard = requirement.loadSavedGame() {
            self.board = savedBoard
            alertTitle = "Partida Cargada"
            alertMessage = "Se ha recuperado tu partida guardada."
            showAlert = true
        } else {
            alertTitle = "Error"
            alertMessage = "No se pudo cargar la partida guardada."
            showAlert = true
        }
    }
    
    @MainActor
    func selectCell(row: Int, col: Int) {
        guard let board = board else { return }
        
        if board.cells[row][col].isEditable {
            selectedCell = (row, col)
        }
    }
    
    @MainActor
    func updateCell(value: Int?) {
        guard let board = board,
              let selected = selectedCell else { return }
        
        var updatedBoard = board
        updatedBoard.cells[selected.row][selected.col].currentValue = value
        self.board = updatedBoard
    }
    
    @MainActor
    func verifySolution() {
        guard let board = board else { return }
        
        if requirement.verifySolution(board: board) {
            alertTitle = "¡Felicidades!"
            alertMessage = "Has completado el Sudoku correctamente. ¡Excelente trabajo!"
            gameCompleted = true
        } else {
            alertTitle = "Solución Incorrecta"
            alertMessage = "Algunos números no son correctos. Revisa tu solución y vuelve a intentarlo."
        }
        
        showAlert = true
    }
    
    @MainActor
    func saveGame() {
        guard let board = board else { return }
        
        requirement.saveGame(board: board)
        alertTitle = "Guardado"
        alertMessage = "Tu progreso ha sido guardado correctamente."
        showAlert = true
    }
    
    @MainActor
    func resetPuzzle() {
        guard let board = board else { return }
        
        var resetBoard = board
        for row in 0..<resetBoard.cells.count {
            for col in 0..<resetBoard.cells[row].count {
                if resetBoard.cells[row][col].isEditable {
                    resetBoard.cells[row][col].currentValue = nil
                }
            }
        }
        
        self.board = resetBoard
        selectedCell = nil
        gameCompleted = false
        
        alertTitle = "Reiniciado"
        alertMessage = "El puzzle ha sido reiniciado. Tus entradas han sido borradas."
        showAlert = true
    }
    
    private func difficultyName(_ difficulty: String) -> String {
        switch difficulty {
        case "easy": return "Fácil"
        case "medium": return "Medio"
        case "hard": return "Difícil"
        default: return difficulty
        }
    }
}
