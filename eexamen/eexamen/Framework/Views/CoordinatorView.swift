//
//  coordinatorView.swift
//  eexamen
//
//  Created by user285809 on 11/27/25.
//

import SwiftUI
import FlowStacks

enum Screen : Hashable{
    case game(size: Int, difficulty: String)
    case savedGame
}

struct Coordinator: View {
    @State var routes: Routes<Screen> = []
    
    var body: some View {
        FlowStack($routes, withNavigation: true) {
            MenuView()
                .flowDestination(for: Screen.self) { screen in
                    switch screen {
                    case .game(let size, let difficulty):
                        GameView(size: size, difficulty: difficulty)
                    case .savedGame:
                        GameView(loadSaved: true)
                    }
                }
        }
    }
}
