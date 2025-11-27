//
//  LocalService.swift
//  eexamen
//
//  Created by user285809 on 11/27/25.
//

import Foundation

class LocalService {
    static let shared = LocalService()
    
    private let savedGameKey = "savedSudokuGame"
    

    func loadLocalPuzzle() -> SudokuPuzzle? {
        guard let url = Bundle.main.url(forResource: "sudoku_puzzle", withExtension: "json") else {
            print("No se encontró el json")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let puzzle = try JSONDecoder().decode(SudokuPuzzle.self, from: data)
            return puzzle
        } catch {
            print("Error al decodificar JSON: \(error)")
            return nil
        }
    }
    
    // Guardar partida en progreso
    func saveGame(board: SudokuBoard) {
        do {
            let data = try JSONEncoder().encode(board)
            UserDefaults.standard.set(data, forKey: savedGameKey)
            print("Partida guardada")
        } catch {
            print("Error al guardar partida: \(error)")
        }
    }
    
    // Cargar partida guardada
    func loadSavedGame() -> SudokuBoard? {
        guard let data = UserDefaults.standard.data(forKey: savedGameKey) else {
            return nil
        }
        
        do {
            let board = try JSONDecoder().decode(SudokuBoard.self, from: data)
            return board
        } catch {
            print("Error al cargar partida guardada: \(error)")
            return nil
        }
    }
    
    // Eliminar partida guardada
    func deleteSavedGame() {
        UserDefaults.standard.removeObject(forKey: savedGameKey)
        print("Partida guardada eliminada")
    }
    
    // Verificar si hay partida guardada
    func hasSavedGame() -> Bool {
        return UserDefaults.standard.data(forKey: savedGameKey) != nil
    }
}
