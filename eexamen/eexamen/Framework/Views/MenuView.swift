//
//  MeNuView.swift
//  eexamen
//
//  Created by user285809 on 11/27/25.
//

import SwiftUI
import FlowStacks

struct MenuView: View {
    @EnvironmentObject var navigator: FlowNavigator<Screen>
    @StateObject var vm = MenuViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Sudoku")
                    .font(.largeTitle.bold())
                    .padding(.top, 40)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Configuración del Puzzle")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Tamaño del tablero:")
                            .font(.subheadline)
                        
                        Picker("Tamaño", selection: $vm.selectedSize) {
                            ForEach(vm.availableSizes, id: \.self) { size in
                                Text("\(size)x\(size)").tag(size)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Dificultad:")
                            .font(.subheadline)
                        
                        Picker("Dificultad", selection: $vm.selectedDifficulty) {
                            ForEach(vm.availableDifficulties, id: \.self) { diff in
                                Text(vm.difficultyDisplayName(diff)).tag(diff)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                Button {
                    navigator.push(.game(size: vm.selectedSize, difficulty: vm.selectedDifficulty))
                } label: {
                    Text("Nuevo Juego")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                
                if vm.hasSavedGame {
                    Button {
                        navigator.push(.savedGame)
                    } label: {
                        Text("Continuar Partida Guardada")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(12)
                    }
                }
                
                Spacer()
                
                Text("Modo: Datos Locales")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 20)
            }
            .padding(.horizontal, 24)
            
        }
        .onAppear {
            vm.checkSavedGame()
        }
    }
}
