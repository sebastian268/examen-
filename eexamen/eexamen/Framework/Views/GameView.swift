//
//  GameView.swift
//  eexamen
//
//  Created by user285809 on 11/27/25.
//

import SwiftUI
import FlowStacks

struct GameView: View {
    @EnvironmentObject var navigator: FlowNavigator<Screen>
    @StateObject var vm = GameViewModel()
    
    let size: Int
    let difficulty: String
    let loadSaved: Bool
    
    init(size: Int = 16, difficulty: String = "easy", loadSaved: Bool = false) {
        self.size = size
        self.difficulty = difficulty
        self.loadSaved = loadSaved
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                
                if vm.isLoading {
                    ProgressView("Cargando puzzle...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                else if let board = vm.board {
                    ScrollView {
                        VStack(spacing: 20) {
                            
                            Text("Sudoku \(board.size)x\(board.size)")
                                .font(.title.bold())
                                .frame(maxWidth: .infinity)
                            
                        
                            SudokuBoardView(board: board, selectedCell: vm.selectedCell) { row, col in
                                vm.selectCell(row: row, col: col)
                            }
                            .frame(
                                width: geo.size.width * 0.9,
                                height: geo.size.width * 0.9
                            )
                            
                            .cornerRadius(12)
                      
                            if vm.selectedCell != nil {
                                NumberPadView { number in
                                    vm.updateCell(value: number)
                                }
                            }
                        
                            VStack(spacing: 12) {
                                HStack(spacing: 12) {
                                    GameButton(text: "Verificar", color: .green, system: "checkmark.circle") {
                                        vm.verifySolution()
                                    }
                                    
                                    GameButton(text: "Guardar", color: .blue, system: "square.and.arrow.down") {
                                        vm.saveGame()
                                    }
                                }
                                
                                HStack(spacing: 12) {
                                    GameButton(text: "Reiniciar", color: .orange, system: "arrow.counterclockwise") {
                                        vm.resetPuzzle()
                                    }
                                    
                                    GameButton(text: "Nuevo Puzzle", color: .purple, system: "plus.circle") {
                                        navigator.goBackToRoot()
                                    }
                                }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                    }
                }
                
                else {
                    Text("No hay puzzle cargado")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
        
        .onAppear {
            if loadSaved {
                vm.loadSavedGame()
            } else {
                Task { await vm.loadNewGame(size: size, difficulty: difficulty) }
            }
        }
        
        .alert(isPresented: $vm.showAlert) {
            Alert(title: Text(vm.alertTitle),
                  message: Text(vm.alertMessage),
                  dismissButton: .default(Text("OK")))
        }
    }
}


struct GameButton: View {
    let text: String
    let color: Color
    let system: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Label(text, systemImage: system)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(color)
                .cornerRadius(12)
        }
    }
}
