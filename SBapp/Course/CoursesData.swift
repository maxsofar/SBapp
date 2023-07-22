//
//  Courses.swift
//  SBapp
//
//  Created by Max on 21/06/2023.
//

import Foundation
import SwiftCSV
import SwiftSoup


// URL of the CSV file on GitHub
let csvURL = URL(string: "https://raw.githubusercontent.com/Cyanivde/StudyBuddy/main/courses.csv")!

struct Exam: Hashable {
    let year: String
    let semester: String
    let links: [String]
}

class Course : ObservableObject, Identifiable, Equatable {
    let id: String
    let name: String
//    var lectureTags: [String]
//    var tutorialTags: [String]
    var lectureTags: [Int: [String]]
    var tutorialTags: [Int: [String]]

    var lectureLinks: [String]
    var lectureRecordingLinks: [String]
    var tutorialLinks: [String]
    var tutorialRecordingLinks: [String]
    let exams: [Exam]
    
    @Published var isFavorite: Bool {
        didSet {
            // Save the state of isFavorite to UserDefaults when it changes
            let key = "isFavorite_\(id)"
            UserDefaults.standard.set(isFavorite, forKey: key)
        }
    }
    @Published var isComplete: [Bool] {
        didSet {
            // Save the state of isComplete to UserDefaults when it changes
            let key = "isComplete_\(id)"
            UserDefaults.standard.set(isComplete, forKey: key)
        }
    }
    
    
    init(
        id: String,
        name: String,
        isFavorite: Bool = false,
//        lectureTags: [String] = [],
//        tutorialTags: [String] = [],
        lectureTags: [Int: [String]] = [:],
        tutorialTags: [Int: [String]] = [:],
        lectureLinks: [String] = [],
        lectureRecordingLinks: [String] = [],
        tutorialLinks: [String] = [],
        tutorialRecordingLinks: [String] = [],
        exams: [Exam] = []
    ) {
        
        self.id = id
        self.name = name
        self.lectureTags = lectureTags
        self.tutorialTags = tutorialTags
        
        // Load the state of isFavorite from UserDefaults when the course is initialized
        let favoriteKey = "isFavorite_\(id)"
        self.isFavorite = UserDefaults.standard.bool(forKey: favoriteKey)
        
        // Load the state of isComplete from UserDefaults when the course is initialized
        let completeKey = "isComplete_\(id)"
        self.isComplete = UserDefaults.standard.array(forKey: completeKey) as? [Bool] ?? Array(repeating: false, count: 13)
        
        self.lectureLinks = lectureLinks
        self.lectureRecordingLinks = lectureRecordingLinks
        self.tutorialLinks = tutorialLinks
        self.tutorialRecordingLinks = tutorialRecordingLinks
        self.exams = exams
    }
}

extension Course {
    static func == (lhs: Course, rhs: Course) -> Bool {
       return lhs.id == rhs.id
   }
    
    func makeFavorite() {
        isFavorite.toggle()
    }
    
    func getIsComplete(for week: Int) -> Bool {
        guard week > 0 && week <= isComplete.count else {
            return false
        }
        return isComplete[week - 1]
    }
        
    func setIsComplete(_ value: Bool, for week: Int) {
        guard week > 0 && week <= isComplete.count else {
            return
        }
        isComplete[week - 1] = value
    }
    
//    func scrape(progressHandler: @escaping (Float) -> Void) {
    
//    func scrape(completion: @escaping () -> Void) {
//                if !lectureLinks.isEmpty || !tutorialLinks.isEmpty  {
//                    defer { completion() }
//                    // The links have already been fetched, so return early
//                    return
//                }
//
//                var request = URLRequest(url: URL(string: "https://studybuddy.co.il/technion/\(id)/lessons")!)
//                request.httpMethod = "GET"
//
//                let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                    defer {  completion() }
//                    guard let data = data, error == nil else {
//                        print("Error downloading HTML: \(error?.localizedDescription ?? "Unknown error")")
//                        return
//                    }
//
//                    if let html = String(data: data, encoding: .utf8) {
//                        do {
//                            let document = try SwiftSoup.parse(html)
//                            // Use SwiftSoup to extract the data from the HTML
//                            let rows = try document.select("tr.course-tr")
//
//                            for row in rows {
//                                let isLectureRow = try row.select("a").first()?.text().contains("הרצאה") ?? false
//
//                                for link in try row.select("td a") {
//                                    let href = try link.attr("href")
//                                    let text = try link.text()
//
//                                    if text.contains("הרצאה") {
//                                        self.lectureLinks.append(href)
//                                    } else if text.contains("תרגול") {
//                                        self.tutorialLinks.append(href)
//                                    } else if text.contains("הקלטה") {
//                                        if isLectureRow {
//                                            self.lectureRecordingLinks.append(href)
//                                        } else {
//                                            self.tutorialRecordingLinks.append(href)
//                                        }
//                                    }
//                                }
//
//                                for badge in try row.select("button.badge") {
//                                    let badgeText = try badge.text()
//
//                                    if isLectureRow {
//                                        self.lectureTags.append(badgeText)
//                                    } else {
//                                        self.tutorialTags.append(badgeText)
//                                    }
//                                }
//                            }
//                        } catch {
//                            print("Error parsing HTML: \(error.localizedDescription)")
//                        }
//                    } else {
//                        print("Error converting data to string")
//                    }
//                }
//                task.resume()
//        }
    
    func scrape(completion: @escaping () -> Void) {
        if !lectureLinks.isEmpty || !tutorialLinks.isEmpty  {
            defer { completion() }
            // The links have already been fetched, so return early
            return
        }
        
        var request = URLRequest(url: URL(string: "https://studybuddy.co.il/technion/\(id)/lessons")!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            defer {
                completion()
            }
            guard let data = data, error == nil else {
                print("Error downloading HTML: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let html = String(data: data, encoding: .utf8) {
                do {
                    let document = try SwiftSoup.parse(html)
                    // Use SwiftSoup to extract the data from the HTML
                    let rows = try document.select("tr.course-tr")
                    
                    var lectureWeekNumber = 0
                    var tutorialWeekNumber = 0
                    
                    for row in rows {
                        let isLectureRow = try row.select("a").first()?.text().contains("הרצאה") ?? false
                        
                        for link in try row.select("td a") {
                            let href = try link.attr("href")
                            let text = try link.text()
                            
                            if text.contains("הרצאה") {
                                self.lectureLinks.append(href)
                            } else if text.contains("תרגול") {
                                self.tutorialLinks.append(href)
                            } else if text.contains("הקלטה") {
                                if isLectureRow {
                                    self.lectureRecordingLinks.append(href)
                                } else {
                                    self.tutorialRecordingLinks.append(href)
                                }
                            }
                        }
                        
                        for badge in try row.select("button.badge") {
                            let badgeText = try badge.text()
                            
                            if isLectureRow {
                                self.lectureTags[lectureWeekNumber, default: []].append(badgeText)
                            } else {
                                self.tutorialTags[tutorialWeekNumber, default: []].append(badgeText)
                            }
                        }
                        
                        if isLectureRow {
                            lectureWeekNumber += 1
                        } else {
                            tutorialWeekNumber += 1
                        }
                    }
                } catch {
                    print("Error parsing HTML: \(error.localizedDescription)")
                }
            } else {
                print("Error converting data to string")
            }
        }
        task.resume()
    }

}

class Courses: ObservableObject {
    @Published var courses: [Course] = []

    func loadCourses(from url: URL, completion: @escaping ([Course]) -> Void) {
        // Create a URLSession data task to load the data from the URL
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Check for errors
            guard let data = data, error == nil else {
                print("Error loading data: \(error!)")
                return
            }

            // Convert the data to a String
            let csvString = String(data: data, encoding: .utf8)!

            // Create a NamedCSV object from the String
            let csv = try! NamedCSV(string: csvString)

            // Access the data by column
            let courseInstituteIDs = csv.columns!["course_institute_id"]!
            let courseNames = csv.columns!["course_name"]!

            // Create an array of Course objects from the CSV data
            var courses = [Course]()
            for i in 0..<courseInstituteIDs.count {
                let id = courseInstituteIDs[i]
                let name = courseNames[i]
//                let course = Course(id: id, name: name)
//                let courseData = testCourses[i % testCourses.count]
                let course = Course(
                    id: id,
                    name: name,
//                    lectureTags: courseData.lectureTags,
//                    tutorialTags: courseData.tutorialTags,
//                    lectureLinks: courseData.lectureLinks,
//                    lectureRecordingLinks: courseData.lectureRecordingLinks,
//                    tutorialLinks: courseData.tutorialLinks,
//                    tutorialRecordingLinks: courseData.tutorialRecordingLinks,
                    exams: testExams
                )
                courses.append(course)
            }
            
            // Call the completion handler with the loaded courses
            completion(courses)
        }

        // Start the data task
        task.resume()
    }
    
    func loadCourses(from url: URL) {
        // Load the courses asynchronously using the loadCourses function
        loadCourses(from: url) { courses in
            // Update the courses property with the loaded courses on the main thread
            DispatchQueue.main.async {
                self.courses = courses.map { courseData in
                    // Create a Course object for each courseData
                    let id = courseData.id
                    let name = courseData.name
                    let key = "isFavorite_\(id)"
                    let isFavorite = UserDefaults.standard.bool(forKey: key)
                    return Course(
                       id: id,
                       name: name,
                       isFavorite: isFavorite,
//                       lectureTags: courseData.lectureTags,
//                       tutorialTags: courseData.tutorialTags,
//                       lectureLinks: courseData.lectureLinks,
//                       lectureRecordingLinks: courseData.lectureRecordingLinks,
//                       tutorialLinks: courseData.tutorialLinks,
//                       tutorialRecordingLinks: courseData.tutorialRecordingLinks,
                       exams: courseData.exams
                   )
                }
            }
        }
    }
}

// Dummy data for exams
let testExams = [
    Exam(year: "2022", semester: "Fall", links: ["https://example.com/exam1", "https://example.com/exam2"]),
    Exam(year: "2022", semester: "Spring", links: ["https://example.com/exam3", "https://example.com/exam4"]),
    Exam(year: "2021", semester: "Fall", links: ["https://example.com/exam5", "https://example.com/exam6"]),
    Exam(year: "2021", semester: "Spring", links: ["https://example.com/exam7", "https://example.com/exam8"])
]

let testCourses = [
    Course(id: "1",
           name: "מתמטיקה",
           lectureTags: [
               1: ["Lorem ipsum dolor "],
               2: ["גיאומטריה", "טריגונומטריה"],
               3: ["סטטיסטיקה"]
           ],
           tutorialTags: [
               1: ["Lorem ipsum dolor sit amet, consectetur adipiscing"],
               2: ["בעיות גיאומטריה", "בעיות טריגונומטריה"],
               3: ["בעיות סטטיסטיקה"]
           ],
           lectureLinks: ["https://mathlecturelink1.com", "https://mathlecturelink2.com"],
           lectureRecordingLinks: ["https://mathlecturerecordinglink1.com", "https://mathlecturerecordinglink2.com"],
           tutorialLinks: ["https://mathtutoriallink1.com", "https://mathtutoriallink2.com"],
           tutorialRecordingLinks: ["https://mathtutorialrecordinglink1.com", "https://mathtutorialrecordinglink2.com"],
           exams: testExams)
]


//let testCourses = [
//    Course(id: "1",
//           name: "מתמטיקה",
//           lectureTags: ["אלגברה", "חשבון", "גיאומטריה", "טריגונומטריה", "סטטיסטיקה"],
//           tutorialTags: ["בעיות אלגברה", "בעיות חשבון", "בעיות גיאומטריה", "בעיות טריגונומטריה", "בעיות סטטיסטיקה"],
//           lectureLinks: ["https://mathlecturelink1.com", "https://mathlecturelink2.com"],
//           lectureRecordingLinks: ["https://mathlecturerecordinglink1.com", "https://mathlecturerecordinglink2.com"],
//           tutorialLinks: ["https://mathtutoriallink1.com", "https://mathtutoriallink2.com"],
//           tutorialRecordingLinks: ["https://mathtutorialrecordinglink1.com", "https://mathtutorialrecordinglink2.com"],
//           exams: testExams),
//    Course(id: "2",
//           name: "פיזיקה",
//           lectureTags: ["מכניקה", "תרמודינמיקה", "אלקטרומגנטיות", "אופטיקה", "מכניקה קוונטית"],
//           tutorialTags: ["בעיות מכניקה", "בעיות תרמודינמיקה", "בעיות אלקטרומגנטיות", "בעיות אופטיקה", "בעיות מכניקה קוונטית"],
//           lectureLinks: ["https://physicslecturelink1.com", "https://physicslecturelink2.com"],
//           lectureRecordingLinks: ["https://physicslecturerecordinglink1.com", "https://physicslecturerecordinglink2.com"],
//           tutorialLinks: ["https://physicstutoriallink1.com", "https://physicstutoriallink2.com"],
//           tutorialRecordingLinks: ["https://physicstutorialrecordinglink1.com", "https://physicstutorialrecordinglink2.com"]),
//    Course(id: "3",
//           name: "כימיה",
//           lectureTags: ["כימיה אורגנית", "כימיה לא אורגנית", "כימיה פיזיקלית", "ביו-כימיה", "אנליזה כימי"],
//           tutorialTags: ["בעיות כימיה אורגני", "בעיות כимия לא אורגני", "בעיות כמי פיזאלי"," בעיות ביו-חמי"," בעיות אנלאל חמי"],
//           lectureLinks: ["https://chemistrylecturelink1.com", "https://chemistrylecturelink2.com"],
//           lectureRecordingLinks: ["https://chemistrylecturerecordinglink1.com", "https://chemistrylecturerecordinglink2.com"],
//           tutorialLinks: ["https://chemistrytutoriallink1.com", "https://chemistrytutoriallink2.com"],
//           tutorialRecordingLinks: ["https://chemistrytutorialrecordinglink1.com", "https://chemistrytutorialrecordinglink2.com"])
//]


