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
    @State var showPlaceholderText = true
    @Namespace private var searchTransition
    @State private var selectedTag: String?
    let viewModel = CourseViewModel(numberOfWeeks: 13)
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack {
                    if !isEditing {
                        HStack {
                            NavigationLink {
                                FavoritesView(courses: courses, viewModel: viewModel)
                            } label: {
                                Image(systemName: "star.circle")
                                    .scaleEffect(1.8)
                                    .foregroundColor(Color.secondary)

                            }
                            Spacer()
                            NavigationLink {
                                LoginView()
                            } label: {
                                Image(systemName: "person.crop.circle")
                                    .scaleEffect(1.8)
                                    .foregroundColor(Color.secondary)
                            }
                        }
                        .padding([.horizontal], 30)
                        .padding([.vertical], 15)
                        Title()
                            .aspectRatio(CGSize(width: 15, height: 3), contentMode: .fit)
                            .padding(20)
                    }
                    
                    ZStack(alignment: isEditing ? .top : .center) {
                        if !isEditing {
                            Image("Leg")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.11, height: geometry.size.height * 1.1 )
                                .offset(x: -geometry.size.width * 0.247, y: -geometry.size.height * 0.072)
                        }
                        SearchBar(isEditing: $isEditing, showPlaceholderText: $showPlaceholderText, courses: courses, geometry: geometry, viewModel: viewModel)
                            .offset(y: isEditing ? 0 : geometry.size.height * 0.43)
                            .matchedGeometryEffect(id: "SearchBar", in: searchTransition)
                        
                        if !isEditing {
                            Image("Foregrnd")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 1.1)
                                .offset(y: -geometry.size.height * 0.233)
                                .allowsHitTesting(false)
                        }
                    }
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
            }
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

