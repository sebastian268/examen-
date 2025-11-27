//
//  SudokuModels.swift
//  eexamen
//
//  Created by user285809 on 11/27/25.
//

import Foundation

struct SudokuPuzzle: Codable {
    let puzzle: [[Int?]]
    let solution: [[Int]]
}

struct PuzzleConfig: Codable {
    let size: Int
    let difficulty: String
}


struct SudokuCell: Identifiable {
    let id = UUID()
    let row: Int
    let col: Int
    let originalValue: Int?
    var currentValue: Int?
    var isEditable: Bool
    
    init(row: Int, col: Int, value: Int?) {
        self.row = row
        self.col = col
        self.originalValue = value
        self.currentValue = value
        self.isEditable = value == nil
    }
}


struct SudokuBoard: Codable {
    var cells: [[SudokuCell]]
    let solution: [[Int]]
    let size: Int
    let difficulty: String
    
    enum CodingKeys: String, CodingKey {
        case cellValues, solution, size, difficulty
    }
    
    init(puzzle: [[Int?]], solution: [[Int]], size: Int, difficulty: String) {
        self.solution = solution
        self.size = size
        self.difficulty = difficulty
        
        var tempCells: [[SudokuCell]] = []
        for row in 0..<puzzle.count {
            var rowCells: [SudokuCell] = []
            for col in 0..<puzzle[row].count {
                let cell = SudokuCell(row: row, col: col, value: puzzle[row][col])
                rowCells.append(cell)
            }
            tempCells.append(rowCells)
        }
        self.cells = tempCells
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let cellValues = try container.decode([[Int?]].self, forKey: .cellValues)
        solution = try container.decode([[Int]].self, forKey: .solution)
        size = try container.decode(Int.self, forKey: .size)
        difficulty = try container.decode(String.self, forKey: .difficulty)
        
        var tempCells: [[SudokuCell]] = []
        for row in 0..<cellValues.count {
            var rowCells: [SudokuCell] = []
            for col in 0..<cellValues[row].count {
                let cell = SudokuCell(row: row, col: col, value: cellValues[row][col])
                rowCells.append(cell)
            }
            tempCells.append(rowCells)
        }
        self.cells = tempCells
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let cellValues = cells.map { row in
            row.map { $0.currentValue }
        }
        try container.encode(cellValues, forKey: .cellValues)
        try container.encode(solution, forKey: .solution)
        try container.encode(size, forKey: .size)
        try container.encode(difficulty, forKey: .difficulty)
    }
}

struct SudokuConfiguration {
    let size: Int
    let difficulty: String
    
    var displaySize: String {
        "\(size)x\(size)"
    }
}
