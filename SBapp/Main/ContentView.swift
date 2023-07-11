//
//  ContentView.swift
//  SBapp
//
//  Created by Max on 21/06/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var courses = Courses()
    @State private var isEditing = false
    @Namespace private var searchTransition
    @State private var selectedTag: String?
    let viewModel = CourseViewModel(numberOfWeeks: 13)
    let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        NavigationStack {
            GeometryReader { vGeometry in
                VStack() {
                    if !isEditing {
                        MainViewToolbar(courses: courses, viewModel: viewModel)
//                            .transition(.move(edge: .top))
                        Title()
                            .aspectRatio(CGSize(width: 15, height: 3), contentMode: .fit)
                            .padding(20)
                            
                    }
                    SearchBarMain(courses: courses, isEditing: $isEditing, vGeometry: vGeometry)
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func dismissKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}

