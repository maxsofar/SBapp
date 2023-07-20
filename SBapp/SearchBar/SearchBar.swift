//
//  searchbar.swift
//  SBapp
//
//  Created by Max on 29/06/2023.
//

import SwiftUI

struct SearchBar: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var courses: Courses
    @Binding var isEditing: Bool
    @State var backButton = false
    @State var searchText = ""
    @State private var searchResults: [Course] = []
    @FocusState  var textFieldIsFocused: Bool
    @State private var alignment: Bool = false
    @State private var phase: CGFloat = 165
    @State var showList = false
    var geoHeight: CGFloat
//    @Namespace private var searchTransition
    
//    @State var selectedTag: String? = nil
    
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
                        Capsule(style: .circular)
                            .fill(colorScheme == .dark ? Color.init(white: 0.3) : Color.init(white: 0.9))
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .strokeBorder(.blue, style: StrokeStyle(lineWidth: 4, dash: [100, 1000], dashPhase: phase))
                            )
                            .padding(.horizontal, 5)
                        TextField("Enter course name or id", text: $searchText)
                            .font(.title2)
                            .disableAutocorrection(true)
                            .allowsHitTesting(false)
                            .multilineTextAlignment(isEditing ? .leading : .center)
                            .padding(.horizontal, 40)
                            .focused($textFieldIsFocused)
                            .submitLabel(.search)
                            .onSubmit {
                                dismissKeyboard()
                            }
                        SearchBarButtons(
                            isEditing: $isEditing,
                            searchText: $searchText,
                            backButton: $backButton,
                            alignment: $alignment,
                            showList: $showList
                        )
                            .padding(.horizontal, 20)
                    }
                }
                .onChange(of: searchText) { newValue in
                    // Update the searchResults property when the searchText property changes
                    searchResults = courses.courses.filter { course in
                        course.name.lowercased().starts(with: searchText.lowercased()) || String(course.id).starts(with: searchText)
                    }
                }
                .onChange(of: courses.courses) { newValue in
                    // Update the searchResults property when the courses.courses property changes
                    searchResults = courses.courses.filter { course in
                        course.name.lowercased().starts(with: searchText.lowercased()) || String(course.id).starts(with: searchText)
                    }
                }
                .onAppear{searchResults = courses.courses}
            }
            .frame(height: geoHeight)
            if showList {
                List(searchResults) { course in
                    NavigationLink(destination:
                        CourseView(course: course)
                    ) {
                        Text(course.name)
                    }
                }
            }
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        @State var isEditing = false
        @State var backButton = false
        @State var isListShown = false
        @State var searchResults: [Course] = []
        let previewCourses = Courses()
        previewCourses.courses = [
                Course(id: "11", name: "Matam", lectureTags: ["Atoms", "Leibniz", "Gamma", "Dopler"], tutorialTags: ["Pascal", "Einstein", "Mu", "Foo"]),
                Course(id: "12", name: "Infi1"),
                Course(id: "13", name: "Physics1m")
            ]
        return
            SearchBar(courses: previewCourses, isEditing: $isEditing, geoHeight: 60)
    }
}


public extension UITextField {
    override var textInputMode: UITextInputMode? {
        let locale = Locale(identifier: "he-IL")
        return UITextInputMode.activeInputModes.first(where: { $0.primaryLanguage == locale.identifier }) ?? super.textInputMode
    }
}
