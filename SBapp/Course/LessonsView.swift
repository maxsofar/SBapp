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

struct ToolbarButtons: View {
    @ObservedObject var course: Course
    @Binding var selectedTag: String?
    @Binding var showFilterButton: Bool
    @State var showingModal = false
    
    var body: some View {
        HStack {
            favoriteButton
            if showFilterButton {
                filterButton
            }
        }
    }
    
    private var favoriteButton: some View {
        Button{
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            course.makeFavorite()
        } label: {
            Image(systemName: course.isFavorite ? "star.fill" : "star")
                .scaleEffect(1.2)
        }
    }
    
    private var filterButton: some View {
        Button() {
            showingModal.toggle()
        } label: {
            Image(systemName: selectedTag == nil ? "line.3.horizontal.decrease.circle"
                    : "line.3.horizontal.decrease.circle.fill"
            )
                .scaleEffect(1.2)
        }
        .sheet(isPresented: $showingModal) {
            FilterList(course: course, selectedTag: $selectedTag, showingModal: $showingModal)
        }
    }
}

struct BottomPositionPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}


struct LessonsView: View {
    @ObservedObject var course: Course
    @Binding var selectedTag: String?
    @State private var showingModal = false
    @Environment(\.colorScheme) var colorScheme
    @State private var showActivityIndicator = false
    @State private var bottomPosition: CGFloat = 0

    //                    if let tag = selectedTag, (course.getTags(week: weekNumber).lecture != tag && course.getTags(week: weekNumber).tutorial != tag) {
    //                        // Skip this week if a tag is selected and it doesn't appear in the course tags for this week
    //                        EmptyView()
    //                    } else {
    //                        weekDisclosureGroup(weekNumber: weekNumber)
    //                            .padding(.horizontal, 10)
    //                    }
    
    var body: some View {
        ZStack(alignment: .center) {
            ScrollView {
                VStack {
                    ForEach(1...13, id: \.self) { weekNumber in
                        
                        weekDisclosureGroup(weekNumber: weekNumber)
//                            .padding(.horizontal, 10)
                            
                    }
                    Spacer().frame(height: 60)
                }
                .background(GeometryReader { geometry in
                    Color.clear
                        .preference(key: BottomPositionPreferenceKey.self, value: geometry.frame(in: .global).maxY)
                })
            }
            .onPreferenceChange(BottomPositionPreferenceKey.self) { value in
                self.bottomPosition = value
            }
            .overlay(
                Image("Lesson_bot")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .position(x: UIScreen.main.bounds.width / 2, y:  bottomPosition - UIScreen.main.bounds.width / 15)
            )
            if showActivityIndicator {
                customActivityIndicator()
                    .offset(y: -40)
            }
        }
        .onAppear {
            showActivityIndicator = true
            
            course.scrape(){
                
                showActivityIndicator = false
            }
        }
        
    }
    
    private func weekDisclosureGroup(weekNumber: Int) -> some View {
        DisclosureGroup {
            WeekView(weekNumber: weekNumber, course: course)
                .padding(.vertical, 10)
        } label: {
            HStack {
                Toggle(isOn: Binding(
                    get: { course.getIsComplete(for: weekNumber) },
                    set: { newValue in
                        course.setIsComplete(newValue, for: weekNumber)
                    }
                )) {}
                .toggleStyle(ChecklistToggleStyle())

                Spacer()
                let localizedWeekString = NSLocalizedString("Week", comment: "")
                Text(localizedWeekString + " \(weekNumber)")
                    .font(.title3)
                    .foregroundColor ({
                        if (!course.getIsComplete(for: weekNumber)) {
                            return colorScheme == .dark ? Color.white : Color.black
                        } else {
                            return Color.gray
                        }
                    }())
                Spacer()
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 10)
        .background(colorScheme == .dark ? Color.init(white: 0.1) : Color.white)
        .cornerRadius(10)
    }
    
    
    
    private var favoriteButton: some View {
        Button{
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            course.makeFavorite()
        } label: {
            Image(systemName: course.isFavorite ? "star.fill" : "star")
                .scaleEffect(1.2)
        }
    }
    
    private var filterButton: some View {
        Button() {
            showingModal.toggle()
        } label: {
            Image(systemName: selectedTag == nil ? "line.3.horizontal.decrease.circle"
                  : "line.3.horizontal.decrease.circle.fill"
            )
                .scaleEffect(1.2)
        }
        .sheet(isPresented: $showingModal) {
            FilterList(course: course, selectedTag: $selectedTag, showingModal: $showingModal)
        }
    }
}


struct LessonsView_Previews: PreviewProvider {
    static var previews: some View {
        @State var selectedTag: String?
        let testCourse = testCourses[0]
        NavigationView {
            LessonsView(course: testCourse, selectedTag: $selectedTag)
        }
    }
}
