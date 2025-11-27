//
//  SudokuBoardView.swift
//  eexamen
//
//  Created by user285809 on 11/27/25.
//

import SwiftUI

struct SudokuBoardView: View {
    let board: SudokuBoard
    let selectedCell: (row: Int, col: Int)?
    let onCellTap: (Int, Int) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let cellSize = size / CGFloat(board.size)
            
            VStack(spacing: 0) {
                ForEach(0..<board.size, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<board.size, id: \.self) { col in
                            let cell = board.cells[row][col]
                            let isSelected = selectedCell?.row == row && selectedCell?.col == col
                            
                            CellView(
                                cell: cell,
                                size: board.size,
                                cellSize: cellSize,
                                isSelected: isSelected
                            )
                            .onTapGesture {
                                onCellTap(row, col)
                            }
                        }
                    }
                }
            }
            .frame(width: size, height: size)
            .border(Color.black, width: 2)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct CellView: View {
    let cell: SudokuCell
    let size: Int
    let cellSize: CGFloat
    let isSelected: Bool
    
    private var borderWidth: CGFloat {
        let subgridSize = Int(sqrt(Double(size)))
        let isRightEdge = (cell.col + 1) % subgridSize == 0
        let isBottomEdge = (cell.row + 1) % subgridSize == 0
        
        if isRightEdge || isBottomEdge {
            return 2
        }
        return 0.5
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(backgroundColor)
                .frame(width: cellSize, height: cellSize)
            
            if let value = cell.currentValue {
                Text("\(value)")
                    .font(.system(size: fontSize))
                    .fontWeight(cell.isEditable ? .regular : .bold)
                    .foregroundColor(cell.isEditable ? .blue : .black)
            }
        }
        .overlay(
            Rectangle()
                .stroke(Color.black, lineWidth: borderWidth)
        )
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return Color.yellow.opacity(0.3)
        } else if !cell.isEditable {
            return Color.gray.opacity(0.2)
        } else {
            return Color.white
        }
    }
    
    private var fontSize: CGFloat {
        switch size {
        case 4:
            return cellSize * 0.5
        case 9:
            return cellSize * 0.4
        case 16:
            return cellSize * 0.35
        default:
            return cellSize * 0.4
        }
    }
}
