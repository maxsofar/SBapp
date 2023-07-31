//
//  ContentView.swift
//  SBapp
//
//  Created by Max on 21/06/2023.
//

import SwiftUI

// URL of the CSV file on GitHub
let csvURL = URL(string: "https://raw.githubusercontent.com/Cyanivde/StudyBuddy/main/courses.csv")!

struct StudyBuddy: View {
    @StateObject private var courses = Courses(from: csvURL)
    @State private var isEditing = false
    @State private var readyToNavigate: Bool = false
    @Namespace private var searchTransition
    @EnvironmentObject var actionService: ActionService
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        NavigationStack {
            GeometryReader { vGeometry in
                ZStack {
                    if !isEditing {
                        Image(colorScheme == .light ? "Back" : "BackDark")
                            .resizable()
                            .ignoresSafeArea(.all)
                            .scaledToFill()
                    }
                    VStack {
                        if !isEditing {
                            MainViewToolbar(courses: courses)
                            Title()
                                .aspectRatio(
                                    CGSize(width: 15, height: 3),
                                    contentMode: .fit
                                )
                                .padding(20)
                        }
                        SearchBarArea(
                            courses: courses,
                            isEditing: $isEditing,
                            vGeometry: vGeometry
                        )
                            .matchedGeometryEffect(id: "searchBar", in: searchTransition)
                    }
                    .onChange(of: scenePhase) { newValue in
                        if newValue == .active {
                                performActionIfNeeded()
                            }
                    }
                    .navigationDestination(isPresented: $readyToNavigate) {
                        Favorites(courses: courses)
                            .onDisappear {
                               ActionService.shared.action = nil
                           }
                    }
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}

extension StudyBuddy {
    private func performActionIfNeeded() {
        // Check the value of the ActionService's action property
        if let action = ActionService.shared.action {
            switch action {
            case .showFavorites:
                readyToNavigate = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StudyBuddy()
    }
}
