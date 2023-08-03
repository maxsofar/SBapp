//
//  CourseView.swift
//  SBapp
//
//  Created by Max on 23/06/2023.
//

import SwiftUI

struct ActivityIndicatorView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.startAnimating()
        return activityIndicator
    }
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {}
}

struct customActivityIndicator: View{
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .frame(maxWidth: 150, maxHeight: 150)
                .foregroundColor(.clear)
                .background(.ultraThinMaterial)
                .cornerRadius(15)
            ActivityIndicatorView()
        }
    }
}

struct ChecklistToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            configuration.label
            Image(systemName: configuration.isOn ? "largecircle.fill.circle" : "circle")
                .scaleEffect(1.3)
                .foregroundColor(configuration.isOn ? .accentColor : .secondary)
                .onTapGesture {
                    configuration.isOn.toggle()
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                }
        }
    }
}

struct BottomPositionPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
    
//    static var defaultValue = CGFloat.zero
//
//    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
//        value += nextValue()
//    }
}

struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}

struct LessonsScrollView: View {
    @ObservedObject var course: Course
    @Binding var selectedTag: String?
    @Binding var bottomPosition: CGFloat
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(1...13, id: \.self) { weekNumber in
                    if let tag = selectedTag, let weeks = course.allTags[tag], !weeks.contains(weekNumber - 1) {
                        // Skip this week if a tag is selected and it doesn't appear in the tags dictionary for this week
                        EmptyView()
                    } else {
                        WeekDisclosureGroup(course: course, weekNumber: weekNumber)
                            .padding(.horizontal, 10)
                    }
                }
                Spacer().frame(height: 60)
            }
            .background(GeometryReader { geometry in
                Color.clear
                    .preference(key: BottomPositionPreferenceKey.self, value: geometry.frame(in: .global).maxY)
            })
        }
        .onPreferenceChange(BottomPositionPreferenceKey.self) { value in
            bottomPosition = value
        }
    }
}




struct LessonsView: View {
    @ObservedObject var course: Course
    @Binding var selectedTag: String?
    @State private var showActivityIndicator = false
    @State private var bottomPosition: CGFloat = 0
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack(alignment: .center) {
            LessonsScrollView(course: course, selectedTag: $selectedTag, bottomPosition: $bottomPosition)
                .overlay(
                    Image("Lesson_bot")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                        .position(x: UIScreen.main.bounds.width / 2, y: bottomPosition - UIScreen.main.bounds.width / 15)
                )
            if showActivityIndicator {
                customActivityIndicator()
                    .offset(y: -40)
            }
        }
        .onAppear {
            showActivityIndicator = true
            course.scrape() {
                self.showActivityIndicator = false
            }
        }
    }
}

//
struct LessonsView_Previews: PreviewProvider {
    static var previews: some View {
        @State var selectedTag: String?
        NavigationView {
            LessonsView(course: testCourses[0], selectedTag: $selectedTag)
        }
    }
}
