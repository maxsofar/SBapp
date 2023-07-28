//
//  ExamDetailView.swift
//  SBapp
//
//  Created by Max on 17/07/2023.
//

import SwiftUI

struct ExamDetailView: View {
    let exam: Exam
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                GroupBox(label:
                    VStack(alignment: .leading) {
                        Text("Exam Form")
                            .font(.title)
                            .padding(.bottom, 0.5)
                    }
                ) {
                    HStack() {
                        if !exam.examFormLinks.isEmpty {
                            Spacer()
                            ForEach(exam.examFormLinks, id: \.self) { link in
                                Link(destination: URL(string: link)!) {
                                    let localizedExamForm = NSLocalizedString("Exam Form", comment: "")
                                    Label(localizedExamForm, systemImage: "link")
                                        .labelStyle(CustomLabelStyle())
                                }
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
                        Text("Solution")
                            .font(.title)
                            .padding(.bottom, 0.5)
                    }
                ) {
                    HStack() {
                        if !exam.solutionLinks.isEmpty {
                            Spacer()
                            ForEach(exam.solutionLinks, id: \.self) { link in
                                Link(destination: URL(string: link)!) {
                                    let localizedSolution = NSLocalizedString("Solution", comment: "")
                                    Label(localizedSolution, systemImage: "link")
                                        .labelStyle(CustomLabelStyle())
                                }
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
                        Text("Recording")
                            .font(.title)
                            .padding(.bottom, 0.5)
                    }
                ) {
                    HStack() {
                        if !exam.recordingLinks.isEmpty {
                            Spacer()
                            ForEach(exam.recordingLinks.indices, id: \.self) { index in
                                let link = exam.recordingLinks[index]
                                Link(destination: URL(string: link)!) {
                                    let localizedRecording = NSLocalizedString("Recording", comment: "")
                                    if exam.recordingLinks.count > 1 {
                                        Label("\(localizedRecording) \(index + 1)", systemImage: "video")
                                            .labelStyle(CustomLabelStyle())
                                    } else {
                                        Label(localizedRecording, systemImage: "video")
                                            .labelStyle(CustomLabelStyle())
                                    }
                                }
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



struct ExamDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ExamDetailView(exam: testExams[0])
    }
}
