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
    @Namespace private var searchTransition
    
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
                    withAnimation(.easeInOut(duration: 0.4)) {
                        isEditing = true
                        backButton = true
                        showList = true
                    }
                } label: {
                    ZStack {
                        Capsule(style: .circular)
                            .fill(colorScheme == .dark ? Color.init(white: 0.3) : Color.init(white: 0.9))
                            .shadow(radius: textFieldIsFocused ? 0 : 5, x: 0, y: textFieldIsFocused ? 0 : 4)
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
                            .padding(.bottom, 5)
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
                .matchedGeometryEffect(id: "list", in: searchTransition)
            }
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    struct PreviewView: View {
            @State var isEditing = false
            @State var backButton = false
            @State var isListShown = false
            @State var searchResults: [Course] = []
            
            var body: some View {
                SearchBar(courses: Courses(testCourses: testCourses), isEditing: $isEditing, geoHeight: 60)
            }
        }
        
    static var previews: some View {
        PreviewView()
    }
}


public extension UITextField {
    override var textInputMode: UITextInputMode? {
        let locale = Locale(identifier: "he-IL")
        return UITextInputMode.activeInputModes.first(where: { $0.primaryLanguage == locale.identifier }) ?? super.textInputMode
    }
}
