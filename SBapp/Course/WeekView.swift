//
//  WeekView.swift
//  SBapp
//
//  Created by Max on 23/06/2023.
//

import SwiftUI

struct WeekView: View {
    let tag: (lecture: String?, tutorial: String?)
    
//    init(
//        (lectureTag: String,
//        lectureTag: String)
//    ) {
//        self.lectureTags = lectureTags
//        self.tutorialTags = tutorialTags
//    }

    var body: some View {
        HStack {
            VStack {
                Link("Lecture", destination: URL(string: "https://technionmail.sharepoint.com/:b:/r/sites/StudyBuddy/Shared%20Documents/114071/Lessons/%D7%94%D7%A8%D7%A6%D7%90%D7%94%201-%2021.10.2020-%20%D7%9E%D7%91%D7%95%D7%90%20%D7%95%D7%90%D7%A0%D7%9C%D7%99%D7%96%D7%AA%20%D7%9E%D7%99%D7%9E%D7%93%D7%99%D7%9D.pdf")!)
                Spacer()
                Link("Tutorial", destination: URL(string: "https://technionmail.sharepoint.com/:b:/r/sites/StudyBuddy/Shared%20Documents/114071/Lessons/%D7%AA%D7%A8%D7%92%D7%99%D7%9C%20%D7%9B%D7%99%D7%AA%D7%94%201%20-%20%D7%97%D7%96%D7%A8%D7%94%20%D7%9E%D7%AA%D7%9E%D7%98%D7%99%D7%AA.pdf")!)
            }
            Spacer()
            VStack {
                Link("Recording", destination: URL(string: "https://panoptotech.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=64d05429-4fa7-4908-9226-ac5b00f3199b")!)
                Spacer()
                Link("Recording", destination: URL(string: "https://panoptotech.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=64006b3d-7c73-4816-90d3-ac5c009d71ff")!)
            }
            Spacer()
            VStack {
                if tag.lecture != nil {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(.gray)
                        Text(tag.lecture!)
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                    .frame(idealWidth: 70, maxWidth: 90, idealHeight: 35, maxHeight: 35)
                }
                if tag.tutorial != nil {
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(.gray)
                        Text(tag.tutorial!)
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                    .frame(idealWidth: 70, maxWidth: 90, idealHeight: 35, maxHeight: 35)
                }
            }
        }
    }
}

struct WeekView_Previews: PreviewProvider {
    static var previews: some View {
        let tags = ["Atoms", "Leibniz"]
        WeekView(tag: (tags[0], tags[1]))
            .frame(width: 380, height: 90)
    }
}
