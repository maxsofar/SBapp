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
        .padding()
        .background(backgroundColor)
        .foregroundColor(foregroundColor)
        .frame(minWidth: 250, maxWidth: 350, minHeight: 150)
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



struct WeekView: View {
    let weekNumber: Int
    let course: Course
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                GroupBox(
                    label: VStack(alignment: .leading) {
                            Text("Lecture")
                                .font(.title)
                                .padding(.bottom, 0.5)
                                if weekNumber - 1 < course.lectureTags.count {
                                    let lectureTopic = course.lectureTags[weekNumber - 1]
                                    Text("\(lectureTopic)")
                                        .font(.title3)
                                }
                            }
                ) {
                    HStack() {
                        
                        if weekNumber - 1 < course.lectureTags.count {
                            VStack(alignment: .center) {
                                ForEach(course.lectureLinks.indices, id: \.self) { index in
                                    let link = course.lectureLinks[index]
                                    Link(destination: URL(string: link)!) {
                                        let localizedLecture = NSLocalizedString("Lecture", comment: "")
                                        Label(localizedLecture + " \(index + 1)", systemImage: "link")
                                            .labelStyle(CustomLabelStyle())
                                    }
                                }
                            }
                            VStack(alignment: .center) {
                                ForEach(course.lectureRecordingLinks.indices, id: \.self) { index in
                                    let link = course.lectureRecordingLinks[index]
                                    Link(destination: URL(string: link)!) {
                                        let localizedRecording = NSLocalizedString("Recording", comment: "")
                                        Label(localizedRecording + " \(index + 1)", systemImage: "video")
                                            .labelStyle(CustomLabelStyle())
                                    }
                                }
                            }
                        }
                        else {
                            VStack {
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                    .padding(.vertical, 10)
                }
                .groupBoxStyle(AutoColorGroupBoxStyle())
                
                GroupBox(
                    label: VStack(alignment: .leading) {
                        Text("Tutorial")
                            .font(.title)
                            .padding(.bottom, 0.5)
                            if weekNumber - 1 < course.tutorialTags.count {
                                let tutorialTopic = course.tutorialTags[weekNumber - 1]
                                Text("\(tutorialTopic)")
                                    .font(.title2)
                            }
                    }
                ) {
                    HStack() {
                        VStack(alignment: .center) {
                            ForEach(course.tutorialLinks.indices, id: \.self) { index in
                                let link = course.tutorialLinks[index]
                                Link(destination: URL(string: link)!) {
                                    let localizedTutorial = NSLocalizedString("Tutorial", comment: "")
                                    Label(localizedTutorial + " \(index + 1)", systemImage: "link")
                                        .labelStyle(CustomLabelStyle())
                                }
                            }
                        }
                        VStack(alignment: .center) {
                            ForEach(course.tutorialRecordingLinks.indices, id: \.self) { index in
                                let link = course.tutorialRecordingLinks[index]
                                Link(destination: URL(string: link)!) {
                                    let localizedRecording = NSLocalizedString("Recording", comment: "")
                                    Label(localizedRecording + " \(index + 1)", systemImage: "video")
                                        .labelStyle(CustomLabelStyle())
                                }
                            }
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
//        let tags = ["Atoms", "Leibniz"]
//        WeekView(tag: (tags[0], tags[1]))
//            .frame(width: 380, height: 90)
        WeekView(weekNumber: 1, course: testCourses[0])
            .frame(width: 380, height: 300)
    }
}
