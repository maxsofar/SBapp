//
//  WeekView.swift
//  SBapp
//
//  Created by Max on 23/06/2023.
//

import SwiftUI

struct AutoColorGroupBoxStyle: GroupBoxStyle {
    @Environment(\.colorScheme) var colorScheme
    
    func makeBody(configuration: Configuration) -> some View {
        let backgroundColor = colorScheme == .dark
        ? Color(red: 0.04, green: 0.13, blue: 0.25)
        : Color(red: 0.78, green: 0.86, blue: 0.9)
        
        let foregroundColor = colorScheme == .dark
        ? Color(red: 0.2, green: 0.55, blue: 0.85)
        : Color(red: 0, green: 0.3, blue: 0.6)
        
        VStack(alignment: .leading) {
            configuration.label
            configuration.content
        }
        .frame(minWidth: 250, maxWidth: UIScreen.main.bounds.width * 0.77)
        .padding()
        .background(backgroundColor)
        .foregroundColor(foregroundColor)
        .cornerRadius(15)
    }
}

struct CustomLabelStyle: LabelStyle {
    @Environment(\.colorScheme) var colorScheme
    
    func makeBody(configuration: Configuration) -> some View {
        let foregroundColor = colorScheme == .dark
        ? Color(red: 0.05, green: 0.2, blue: 0.4)
        : Color(red: 0.67, green: 0.8, blue: 0.86)
        
        HStack {
            configuration.icon
            configuration.title
                .font(.headline)
        }
        .padding(15)
        .background(foregroundColor)
        .cornerRadius(8)
    }
}

struct LinksView: View {
    let links: [String]

    var body: some View {
        VStack {
            ForEach(links.indices, id: \.self) { index in
                let link = links[index]
                Link(destination: URL(string: link)!) {
                    let localizedRecording = NSLocalizedString("Recording", comment: "")
                    if links.count > 1 {
                        let localizedRecordingWithIndex = NSLocalizedString("Recording %d", comment: "")
                        Label(String(format: localizedRecordingWithIndex, index + 1), systemImage: "video")
                            .labelStyle(CustomLabelStyle())
                    } else {
                        Label(localizedRecording, systemImage: "video")
                            .labelStyle(CustomLabelStyle())
                    }
                }
            }
        }
    }
}




struct WeekView: View {
    let weekNumber: Int
    let course: Course
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                GroupBox(label:
                    VStack(alignment: .leading) {
                        Text("Lecture")
                            .font(.title)
                            .padding(.bottom, 0.5)
                    if !course.lectureTags.isEmpty && !course.lectureTags[weekNumber - 1].isEmpty {
                            let lectureBadges = course.lectureTags[weekNumber - 1]
                        
                            ForEach(lectureBadges, id: \.self) { lectureBadge in
                                Text(lectureBadge)
                                    .font(.title3)
                            }
                        }
                    }
                ) {
                    HStack() {
                        if course.lectureLinks.indices.contains(weekNumber - 1)  ||
                            course.lectureRecordingLinks.indices.contains(weekNumber - 1) 
                        {
                            Spacer()
                            if(course.lectureLinks.indices.contains(weekNumber - 1)) {
                                let link = course.lectureLinks[weekNumber - 1]
                                Link(destination: URL(string: link)!) {
                                    let localizedLecture = NSLocalizedString("Lecture", comment: "")
                                    Label(localizedLecture, systemImage: "link")
                                        .labelStyle(CustomLabelStyle())
                                }
                            }
                            if course.lectureRecordingLinks.indices.contains(weekNumber - 1) {
                                let links = course.lectureRecordingLinks[weekNumber - 1]
                                LinksView(links: links)
                            }
                            Spacer()
                        } else {
                            Spacer()
                            let localizedND = NSLocalizedString("No Data", comment: "")
                            Label(localizedND, systemImage: "nosign")
                                .labelStyle(CustomLabelStyle())
                            Spacer()
                        }
                    }
                    .padding(.vertical, 10)
                }
                .groupBoxStyle(AutoColorGroupBoxStyle())
                
                GroupBox(label:
                    VStack(alignment: .leading) {
                        Text("Tutorial")
                            .font(.title)
                            .padding(.bottom, 0.5)
                    if !course.tutorialTags.isEmpty && !course.tutorialTags[weekNumber - 1].isEmpty {
                            let tutorialBadges = course.tutorialTags[weekNumber - 1]
                                ForEach(tutorialBadges, id: \.self) { tutorialBadge in
                                    Text(tutorialBadge)
                                        .font(.title3)
                                }
                            }
                    }
                ) {
                    HStack() {
                        if course.tutorialLinks.indices.contains(weekNumber - 1)  ||
                            course.tutorialRecordingLinks.indices.contains(weekNumber - 1)
                        {
                            Spacer()
                            if(course.tutorialLinks.indices.contains(weekNumber - 1)) {
                                let link = course.tutorialLinks[weekNumber - 1]
                                    Link(destination: URL(string: link)!) {
                                        let localizedTutorial = NSLocalizedString("Tutorial", comment: "")
                                        Label(localizedTutorial, systemImage: "link")
                                            .labelStyle(CustomLabelStyle())
                                    }
                            }
                            if course.tutorialRecordingLinks.indices.contains(weekNumber - 1) {
                                let links = course.tutorialRecordingLinks[weekNumber - 1]
                                LinksView(links: links)
                            }
                            Spacer()
                            
                        } else {
                            Spacer()
                            let localizedND = NSLocalizedString("No Data", comment: "")
                            Label(localizedND, systemImage: "nosign")
                                .labelStyle(CustomLabelStyle())
                            Spacer()
                        }
                    }
                    .padding(.vertical, 10)
                }
                .groupBoxStyle(AutoColorGroupBoxStyle())
            }
        }
    }
}

struct WeekView_Previews: PreviewProvider {
    static var previews: some View {
        WeekView(weekNumber: 1, course: testCourses[0])
            .padding(.horizontal, 10)
            
    }
}
