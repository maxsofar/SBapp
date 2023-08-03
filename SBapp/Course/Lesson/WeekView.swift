//
//  WeekView.swift
//  SBapp
//
//  Created by Max on 23/06/2023.
//

import SwiftUI

struct WeekView: View {
    let weekNumber: Int
    let course: Course
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                cardTitleView(materialType: "Lecture", systemImage: "link", badges: course.lectureTags, links: course.lectureLinks, recordingLinks: course.lectureRecordingLinks, weekNumber: weekNumber)
                cardTitleView(materialType: "Tutorial", systemImage: "link", badges: course.tutorialTags, links: course.tutorialLinks, recordingLinks: course.tutorialRecordingLinks, weekNumber: weekNumber)
            }
        }
    }
}

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
        .frame(minWidth: 250, maxWidth: UIScreen.main.bounds.width * 0.7)
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

func recordingLinkView(links: [String]) -> some View {
    VStack {
        ForEach(links.indices, id: \.self) { index in
            if let link = URL(string: links[index]) {
                Link(destination: link) {
                    if links.count > 1 {
                        let localizedRecordingWithIndex = NSLocalizedString("Recording %d", comment: "")
                        Label(String(format: localizedRecordingWithIndex, index + 1), systemImage: "video")
                            .labelStyle(CustomLabelStyle())
                    } else {
                        let localizedRecording = NSLocalizedString("Recording", comment: "")
                        Label(localizedRecording, systemImage: "video")
                            .labelStyle(CustomLabelStyle())
                    }
                }
            }
        }
    }
}

func materialLinkView(materialType: String, systemImage: String, links: [String], recordingLinks: [[String]], weekNumber: Int) -> some View {
    HStack() {
        if links.indices.contains(weekNumber - 1), let url = URL(string: links[weekNumber - 1]) {
            Spacer(minLength: 0)
            Link(destination: url) {
                let localizedMaterial = NSLocalizedString(materialType, comment: "")
                Label(localizedMaterial, systemImage: systemImage)
                    .labelStyle(CustomLabelStyle())
            }
            Spacer(minLength: 0)
        }
        if recordingLinks.indices.contains(weekNumber - 1) && !recordingLinks[weekNumber - 1].isEmpty {
            Spacer(minLength: 0)
            recordingLinkView(links: recordingLinks[weekNumber - 1])
            Spacer(minLength: 0)
        }
        if !links.indices.contains(weekNumber - 1) && !recordingLinks.indices.contains(weekNumber - 1) {
            Spacer()
            let localizedND = NSLocalizedString("No Data", comment: "")
            Label(localizedND, systemImage: "nosign")
                .labelStyle(CustomLabelStyle())
            Spacer()
        }
    }
    .padding(.vertical, 10)
}

func cardTitleView(materialType: String, systemImage: String, badges: [[String]], links: [String], recordingLinks: [[String]], weekNumber: Int) -> some View {
    GroupBox(label:
        VStack(alignment: .leading) {
        let localizedMaterial = NSLocalizedString(materialType, comment: "")
            Text(localizedMaterial)
                .font(.title)
                .padding(.bottom, 0.5)
            if !badges.isEmpty && !badges[weekNumber - 1].isEmpty {
                let badgeList = badges[weekNumber - 1]
                ForEach(badgeList, id: \.self) { badge in
                    Text(badge)
                        .font(.title3)
                }
            }
        }
    ) {
        materialLinkView(materialType: materialType, systemImage: systemImage, links: links, recordingLinks: recordingLinks, weekNumber: weekNumber)
    }
    .groupBoxStyle(AutoColorGroupBoxStyle())
}

struct WeekView_Previews: PreviewProvider {
    static var previews: some View {
        WeekView(weekNumber: 1, course: testCourses[0])
            .padding(.horizontal, 10)
            .environment(\.locale, .init(identifier: "he"))
            
    }
}
