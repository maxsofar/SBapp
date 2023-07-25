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
        Text("Hello World")
//        VStack(alignment: .center) {
//            ForEach(exam.links.indices, id: \.self) { index in
//                let link = exam.links[index]
//                Link(destination: URL(string: link)!) {
//                    Label("Link \(index + 1)", systemImage: "link")
//                        .labelStyle(CustomLabelStyle())
//                }
//            }
//        }
    }
}


//struct ExamDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExamDetailView(exam: testExams[0])
//    }
//}
