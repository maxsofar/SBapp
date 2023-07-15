//
//  ContentView.swift
//  SBapp
//
//  Created by Max on 21/06/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var courses = Courses()
    @State private var isEditing = false
//    @Namespace private var searchTransition
    @State private var selectedTag: String?
    
    var body: some View {
        NavigationStack {
            GeometryReader { vGeometry in
                VStack() {
                    if !isEditing {
                        MainViewToolbar(courses: courses)
                        Title()
                            .aspectRatio(CGSize(width: 15, height: 3), contentMode: .fit)
                            .padding(20)
                    }
                    SearchBarMain(courses: courses, isEditing: $isEditing, vGeometry: vGeometry)
                        
                }
            }
            .onAppear {
                if courses.courses.isEmpty {
                courses.loadCourses(from: csvURL)
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


