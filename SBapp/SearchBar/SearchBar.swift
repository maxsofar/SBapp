//
//  searchbar.swift
//  SBapp
//
//  Created by Max on 29/06/2023.
//

import SwiftUI

public extension UITextField {
    override var textInputMode: UITextInputMode? {
        let locale = Locale(identifier: "he-IL")
        return UITextInputMode.activeInputModes.first(where: { $0.primaryLanguage == locale.identifier }) ?? super.textInputMode
    }
}

struct CapsuleStyle: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var isEditing: Bool
    @Binding var phase: CGFloat
    
    var body: some View {
        Capsule(style: .circular)
            .fill(colorScheme == .dark ? Color.init(white: 0.3) : Color.init(white: 0.9))
            .shadow(radius: isEditing ? 0 : 5, x: 0, y: isEditing ? 0 : 4)
            .overlay(
                Capsule(style: .circular)
                    .strokeBorder(Color.init(white: 0.7), style: StrokeStyle(lineWidth: 3, dash: [100, 1000], dashPhase: phase))
            )
            .padding(.horizontal, 5)
    }
}


struct TextFieldStyle: ViewModifier {
    @Binding var isEditing: Bool
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .disableAutocorrection(true)
            .allowsHitTesting(false)
            .multilineTextAlignment(.leading)
            .padding(.leading, isEditing ? 45 : UIScreen.main.bounds.width / 2 - 110)
            .padding(.bottom, 5)
            .onSubmit {
                dismissKeyboard()
        }

    }
}

class SearchViewModel: ObservableObject {
    @Published var searchResults: [Course] = []
    var courses: Courses
    
    init(courses: Courses) {
        self.courses = courses
    }
    
    func search(for searchText: String) {
        searchResults = courses.courses.filter { course in
            course.name.lowercased().starts(with: searchText.lowercased()) || String(course.id).starts(with: searchText)
        }
    }
}

struct SearchBar: View {
    @Namespace private var searchTransition
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var courses: Courses
    @StateObject var searchViewModel: SearchViewModel
    @Binding var isEditing: Bool
    var searchBarHeight: CGFloat
    
    @FocusState private var textFieldIsFocused: Bool
    @State private var showList = false
    @State private var backButton = false
    @State private var searchText = ""
    @State private var animationPhase: CGFloat = 165
    
    init(courses: Courses, isEditing: Binding<Bool>, searchBarHeight: CGFloat) {
            self.courses = courses
            self._isEditing = isEditing
            self.searchBarHeight = searchBarHeight
            self._searchViewModel = StateObject(wrappedValue: SearchViewModel(courses: courses))
        }
    
    var body: some View {
        VStack {
            ZStack {
                Button(action: startSearch) {
                    ZStack {
                        CapsuleStyle(isEditing: $isEditing, phase: $animationPhase)
                        
                        TextField("Enter course name or id", text: $searchText)
                        .modifier(TextFieldStyle(isEditing: $isEditing))
                        .focused($textFieldIsFocused)
                        .onChange(of: searchText) { newValue in
                            searchViewModel.search(for: newValue)
                        }

                        SearchBarButtons(
                            isEditing: $isEditing,
                            searchText: $searchText,
                            backButton: $backButton,
                            showList: $showList
                        )
                            .padding(.horizontal, 20)
                    }
                }
            }
            .frame(height: searchBarHeight)
            .toolbar { }
            if showList {
                List(searchViewModel.searchResults) { course in
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

extension SearchBar {
    func startSearch() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        if !isEditing {
            generator.impactOccurred()
            animationPhase = 165
            withAnimation(.linear(duration: 1.5)) {
                animationPhase -= 1165
            }
        }
        textFieldIsFocused = true
        withAnimation(.easeInOut(duration: 0.4)) {
            isEditing = true
            backButton = true
            showList = true
        }
        searchViewModel.search(for: searchText)
    }
}

struct SearchBar_Previews: PreviewProvider {
    struct PreviewView: View {
            @State var isEditing = false
            @State var backButton = false
            @State var isListShown = false
            @State var searchResults: [Course] = []
            
            var body: some View {
                SearchBar(courses: Courses(testCourses: testCourses), isEditing: $isEditing, searchBarHeight: 60)
            }
        }
        
    static var previews: some View {
        PreviewView()
    }
}

