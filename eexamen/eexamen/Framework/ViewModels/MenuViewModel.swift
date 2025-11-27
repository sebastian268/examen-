//
//  MenuViewModel.swift
//  eexamen
//
//  Created by user285809 on 11/27/25.
//

import Foundation
import Combine

class MenuViewModel: ObservableObject {
    @Published var selectedSize: Int = 16
    @Published var selectedDifficulty: String = "easy"
    @Published var hasSavedGame: Bool = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var isLoading = false
    
    let availableSizes = [4, 9, 16]
    let availableDifficulties = ["easy", "medium", "hard"]
    
    var requirement: SudokuRequirementProtocol
    
    init(requirement: SudokuRequirementProtocol = SudokuRequirement.shared) {
        self.requirement = requirement
        checkSavedGame()
    }
    
    @MainActor
    func checkSavedGame() {
        hasSavedGame = requirement.hasSavedGame()
    }
    
    func difficultyDisplayName(_ difficulty: String) -> String {
        switch difficulty {
        case "easy": return "Fácil"
        case "medium": return "Medio"
        case "hard": return "Difícil"
        default: return difficulty
        }
    }
}
