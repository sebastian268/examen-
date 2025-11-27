//
//  numberPadView.swift
//  eexamen
//
//  Created by user285809 on 11/27/25.
//

import SwiftUI

struct NumberPadView: View {
    let onNumberTap: (Int?) -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Selecciona un número:")
                .font(.headline)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 4), spacing: 8) {
                ForEach(1...16, id: \.self) { number in
                    Button {
                        onNumberTap(number)
                    } label: {
                        Text("\(number)")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
                
                Button {
                    onNumberTap(nil)
                } label: {
                    Text("Borrar")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.red)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

