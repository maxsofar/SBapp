//
//  searchbar.swift
//  SBapp
//
//  Created by Max on 29/06/2023.
//

import SwiftUI

struct SearchBar: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var isEditing: Bool
    @State var backButton = false
    @State var searchText = ""
    @ObservedObject var courses: Courses
    @State private var searchResults: [Course] = []
    @FocusState  var textFieldIsFocused: Bool
    @State private var alignment: Bool = false
    @State private var phase: CGFloat = 165
    @State var showList = false
    var geoHeight: CGFloat
    let viewModel: CourseViewModel
    
    var body: some View {
        VStack {
            ZStack {
                Button{
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    if !isEditing {
                        generator.impactOccurred()
                        phase = 165
                        withAnimation(.linear(duration: 1.5)) {
                            phase -= 1165
                        }
                    }
                    textFieldIsFocused = true
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isEditing = true
                        backButton = true
                        showList = true
                    }
                } label: {
                    ZStack {
                        Capsule(style: .continuous)
                            .fill(colorScheme == .dark ? Color.init(white: 0.2) : Color.init(white: 0.9))
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .strokeBorder(.blue, style: StrokeStyle(lineWidth: 4, dash: [100, 1000], dashPhase: phase))
                            )
                            .padding([.horizontal], 5)
                        TextField("Enter course name or id", text: $searchText)
                            .font(.title2)
                            .disableAutocorrection(true)
                            .allowsHitTesting(false)
                            .multilineTextAlignment(isEditing ? .leading : .center)
                            .padding([.horizontal], 40)
                            .focused($textFieldIsFocused)
                            .onAppear {
                                searchResults = courses.courses
                            }
                            .onChange(of: searchText) { newValue in
                                // Perform the search using searchText
                                searchResults = courses.courses.filter { course in
                                    course.name.lowercased().starts(with: searchText.lowercased()) || String(course.id).starts(with: searchText)
                                }
                            }
                            .submitLabel(.search)
                            .onSubmit {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                        SearchBarButtons(
                            isEditing: $isEditing,
                            searchText: $searchText,
                            backButton: $backButton,
                            alignment: $alignment,
                            showList: $showList
                        )
                            .padding([.horizontal], 20)
                    }
                }
            }
            .frame(height: geoHeight)
            if showList {
                List(searchResults) { course in
                    NavigationLink(destination: CourseView(course: course, viewModel: viewModel)) {
                        Text(course.name)
                    }
                }
            }
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    @State private var isEditing = false
    static var previews: some View {
        ContainerView()
    }
    
    struct ContainerView: View {
        @State private var isEditing = false
        @State private var backButton = false
        @State private var isListShown = false
        @State var searchResults: [Course] = []
        var courses = Courses()
        let viewModel = CourseViewModel(numberOfWeeks: 13)
        var body: some View {
            GeometryReader{ geometry in
                SearchBar(isEditing: $isEditing, courses: courses, geoHeight: geometry.size.height * 0.08, viewModel: viewModel)
            }
        }
    }
}
