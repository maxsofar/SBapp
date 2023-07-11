//
//  CourseView.swift
//  SBapp
//
//  Created by Max on 23/06/2023.
//

import SwiftUI

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

class CourseViewModel: ObservableObject {
    @Published var isComplete: [Bool]
    init(numberOfWeeks: Int) {
        self.isComplete = Array(repeating: false, count: numberOfWeeks)
    }
}

struct CourseView: View {
    @ObservedObject var viewModel: CourseViewModel
    @State private var showingModal = false
    @Environment (\.colorScheme) var colorScheme
    var course: Course
    @State private var isFavorite: Bool
    @State private var selectedTag: String?

    
    init(course: Course, selectedTag: String? = nil, viewModel: CourseViewModel) {
        self.viewModel = viewModel
        self.course = course
        _isFavorite = State(initialValue: course.isCourseFavorite())
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(1...13, id: \.self) { weekNumber in
                    if let tag = selectedTag, (course.getTags(week: weekNumber).lecture != tag && course.getTags(week: weekNumber).tutorial != tag) {
                        // Skip this week if a tag is selected and it doesn't appear in the course tags for this week
                        EmptyView()
                    } else {
                        DisclosureGroup {
                            WeekView(tag: course.getTags(week: weekNumber))
                                .padding([.vertical], 30)
                                .padding([.horizontal], 10)
                        } label: {
                            HStack {
                                Toggle(isOn: $viewModel.isComplete[weekNumber - 1]) {}
                                    .toggleStyle(ChecklistToggleStyle())
                                Spacer()
                                Text("Week \(weekNumber)")
                                    .frame(width: 75)
                                    .font(.title3)
                                    .foregroundColor ({
                                        if (!viewModel.isComplete[weekNumber - 1]) {
                                            return colorScheme == .dark ? Color.white : Color.black
                                        } else {
                                            return Color.gray
                                        }
                                    }())
                                Spacer()
                                
                            }
                        }
                        .padding([.horizontal], 10)
                        .padding([.vertical], 10)
                        .frame(maxWidth: .infinity)
                        .background(colorScheme == .dark ? Color.init(white: 0.2) : Color.white)
                        .cornerRadius(10)
                        //                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                    }
                }
            }
            .padding([.vertical], 30)
            .padding([.horizontal], 10)
        }
        .background(colorScheme == .dark ? Color.clear : Color.init(white: 0.95))
        .navigationTitle(course.getName())
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup {
                Button{
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                    isFavorite.toggle()
                    course.makeFavorite()
                } label: {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .scaleEffect(1.2)
                }
                Button() {
                    showingModal.toggle()
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .scaleEffect(1.2)
                }
                .sheet(isPresented: $showingModal) {
                    VStack(alignment: .leading) {
                        Text("Filter by Topic")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding([.horizontal], 30)
                            .padding([.top], 40)
                        List {
                            Button {
                                selectedTag = nil
                                showingModal = false
                            } label: {
                                HStack {
                                    Text("All")
                                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                    if selectedTag == nil {
                                        Spacer()
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                            ForEach(0..<max(course.lectureTags.count, course.tutorialTags.count), id: \.self) { index in
                                if index < course.lectureTags.count {
                                    Button {
                                        selectedTag = course.lectureTags[index]
                                        showingModal = false
                                    } label: {
                                        HStack {
                                            Text(course.lectureTags[index])
                                                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                            if selectedTag == course.lectureTags[index] {
                                                Spacer()
                                                Image(systemName: "checkmark")
                                            }
                                        }
                                    }
                                }
                                if index < course.tutorialTags.count {
                                    Button {
                                        selectedTag = course.lectureTags[index]
                                        showingModal = false
                                    } label: {
                                        HStack {
                                            Text(course.tutorialTags[index])
                                                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                            if selectedTag == course.tutorialTags[index] {
                                                Spacer()
                                                Image(systemName: "checkmark")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding([.top], -20)
                    }
                    .background(colorScheme == .light ? Color(UIColor.secondarySystemBackground) : Color(UIColor.systemGroupedBackground)) 
                }
            }
        }
    }
}

struct CourseView_Previews: PreviewProvider {
    static var previews: some View {
        let matam = Course(id: 11, name: "Matam")
        let viewModel = CourseViewModel(numberOfWeeks: 13)
        CourseView(course: matam, viewModel: viewModel)
    }
}
