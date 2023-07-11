//
//  searchbar.swift
//  SBapp
//
//  Created by Max on 29/06/2023.
//

import SwiftUI

struct SearchBar: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding  var isEditing: Bool
    @Binding  var showPlaceholderText: Bool
    @State var searchText = ""
    @ObservedObject var courses: Courses
    @State var searchResults: [Course] = []
    @FocusState  var textFieldIsFocused: Bool
    @State private var backButton = false
    @State private var alignment: Bool = false
    @State private var phase: CGFloat = 165
    let geometry: GeometryProxy
    let viewModel: CourseViewModel
    
    var body: some View {
        GeometryReader {geometry in
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
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                            backButton = true
                        }
                        
                        
                    } label: {
                        HStack {
                            TextField("Enter course name or id", text: $searchText)
                                .font(.title2)
                                .disableAutocorrection(true)
                                .frame(width: max(geometry.size.width - 80, 0), height: geometry.size.height * 0.07)
                                .allowsHitTesting(false)
                                .multilineTextAlignment(isEditing ? .leading : .center)
                                .padding([.horizontal], 40)
                                .background(
                                    ZStack {
                                        Capsule(style: .continuous)
                                            .fill(colorScheme == .dark ? Color.init(white: 0.3) : Color.init(white: 0.9))
                                            .overlay(
                                                    RoundedRectangle(cornerRadius: 25)
                                                        .strokeBorder(.blue, style: StrokeStyle(lineWidth: 4, dash: [100, 1000], dashPhase: phase))
                                            )
                                            .padding([.horizontal], 5)
                                        SearchBarButtons(
                                            isEditing: $isEditing,
                                            searchText: $searchText,
                                            showPlaceholderText: $showPlaceholderText,
                                            backButton: $backButton,
                                            alignment: $alignment)
                                            .padding([.horizontal], 20)
                                    }
                                )
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
                        }
                    }
                }
                if backButton {
                    List(searchResults) { course in
                        NavigationLink(destination: CourseView(course: course, viewModel: viewModel)) {
                            Text(course.name)
                        }
                    }
                }
            }
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ContainerView()
        }
    }
    
    struct ContainerView: View {
        @State private var isEditing = false
        @State var offset: CGFloat = 0
        @State var showPlaceholderText = true
        var courses = Courses()
        let viewModel = CourseViewModel(numberOfWeeks: 13)
        var body: some View {
            GeometryReader { geometry in
                SearchBar(isEditing: $isEditing, showPlaceholderText: $showPlaceholderText, courses:courses, geometry: geometry, viewModel: viewModel)
            }
            .previewLayout(.fixed(width: 400, height: 60))
        }
    }
}
