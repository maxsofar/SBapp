//
//  WeekDisclosureGroup.swift
//  SBapp
//
//  Created by Max on 30/07/2023.
//

import SwiftUI

struct WeekDisclosureGroup: View {
    @ObservedObject var course: Course
    @Environment(\.colorScheme) var colorScheme
    let weekNumber: Int
    
    var body: some View {
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
}


//struct WeekDisclosureGroup_Previews: PreviewProvider {
//    static var previews: some View {
//        WeekDisclosureGroup(course: testCourses[0], weekNumber: 1)
//    
//    }
//}
