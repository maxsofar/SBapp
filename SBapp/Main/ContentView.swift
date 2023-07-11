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
    @State var offset: CGFloat = 0
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
                        Title()
                            .aspectRatio(CGSize(width: 15, height: 3), contentMode: .fit)
                            .padding(20)
                    }
                    ZStack (){
                        GeometryReader { zGeometry in
                            if !isEditing {
                                Image("Leg")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                            SearchBar(
                                isEditing: $isEditing,
                                courses: courses,
                                geoHeight:  vGeometry.size.height * 0.08,
                                viewModel: viewModel
                            )
                            .offset(y: isEditing ? 0 : zGeometry.size.width * 0.65)
                            .matchedGeometryEffect(id: "SearchBar", in: searchTransition)
                            
                            if !isEditing {
                                Image("Foregrnd")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .allowsHitTesting(false)
                            }
                        }
                    }
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

