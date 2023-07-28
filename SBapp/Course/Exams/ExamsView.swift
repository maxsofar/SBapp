//
//  ExamsView.swift
//  SBapp
//
//  Created by Max on 17/07/2023.
//

import SwiftUI

struct ExamsView: View {
    @ObservedObject var course: Course
    @State var selectedTag: String?
    @State var showingModal = false
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        Color.black
//        ScrollView {
//            VStack {
//                ForEach(course.exams, id: \.self) { exam in
//                    if let tag = selectedTag, exam.year != tag {
//                        // Skip this exam if a tag is selected and it doesn't match the exam tag
//                        EmptyView()
//                    } else {
//                        examDisclosureGroup(exam: exam)
//                    }
//                }
//            }
//            .padding(.vertical, 30)
//            .padding(.horizontal, 10)
//        }
//        .background(colorScheme == .dark ? Color.clear : Color.init(white: 0.95))
    }
    
//    private func examDisclosureGroup(exam: Exam) -> some View {
//        DisclosureGroup {
//            ExamDetailView(exam: exam)
//                .padding(.vertical, 10)
//        } label: {
//            HStack {
//                Text(exam.year + " " + exam.semester)
//                    .font(.title3)
//                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
//                Spacer()
//            }
//        }
//        .padding(.vertical, 10)
//        .padding(.horizontal, 10)
//        .background(colorScheme == .dark ? Color.init(white: 0.1) : Color.white)
//        .cornerRadius(10)
//    }
    
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
}


struct ExamsView_Previews: PreviewProvider {
    static var previews: some View {
        ExamsView(course: testCourses[0])
    }
}
