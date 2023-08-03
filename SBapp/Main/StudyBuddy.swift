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
    @State private var showSplash = true
    @State private var scale: CGFloat = 0.9
    @State private var offset: CGFloat = UIScreen.main.bounds.height / 2.85
    @State private var hasAnimated: Bool = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { vGeometry in
                ZStack {
                    if !isEditing {
                        if showSplash {
                            let red = 76.0 / 255.0
                            let green = 100.0 / 255.0
                            let blue = 236.0 / 255.0
                            Color(red: red, green: green, blue: blue)
                                .ignoresSafeArea()

                        } else {
                            Image("Back")
                                .resizable()
                                .ignoresSafeArea(.all)
                                .scaledToFill()
                                .transition(.opacity)
                        }
                    }
                    VStack {
                        if !isEditing {
                            MainViewToolbar(courses: courses)
                                .opacity(showSplash ? 0 : 1)
                            Title(hasAnimated: $hasAnimated)
//                                .position(x: vGeometry.size.width / 2, y: position)
                                .offset(y: offset)
                                .scaleEffect(scale)
                        }
                            
                            SearchBarArea(
                                courses: courses,
                                isEditing: $isEditing,
                                vGeometry: vGeometry
                            )
                            .matchedGeometryEffect(id: "searchBar", in: searchTransition)
                            .opacity(showSplash ? 0 : 1)
                        
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
                .onAppear {
                    if !hasAnimated {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                self.scale  = UIScreen.main.bounds.width / 380
                                self.offset = 0
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
                            withAnimation(.easeInOut(duration: 0.8)) {
                                self.showSplash = false
                            }
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
