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

class Exam {
    var semesterYear: String
    var examFormLinks: [String]
    var solutionLinks: [String]
    var recordingLinks: [String]
    var subjects: [Int: [String]]

    init(semesterYear: String, examFormLinks: [String], solutionLinks: [String], recordingLinks: [String], subjects: [Int: [String]]) {
        self.semesterYear = semesterYear
        self.examFormLinks = examFormLinks
        self.solutionLinks = solutionLinks
        self.recordingLinks = recordingLinks
        self.subjects = subjects
    }
}


class Course : ObservableObject, Identifiable, Equatable {
    let id: String
    let name: String
    var lectureTags: [[String]]
    var tutorialTags: [[String]]
    var lectureLinks: [String]
    var lectureRecordingLinks: [[String]]
    var tutorialLinks: [String]
    var tutorialRecordingLinks: [[String]]
    var exams: [Exam]
    
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
        lectureTags: [[String]] = [],
        tutorialTags: [[String]] = [],
        lectureLinks: [String] = [],
        lectureRecordingLinks: [[String]] = [],
        tutorialLinks: [String] = [],
        tutorialRecordingLinks: [[String]] = [],
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
    var allTags: [String: [Int]] {
            var tags: [String: [Int]] = [:]
            for (weekNumber, lectureBadges) in lectureTags.enumerated() {
                for lectureBadge in lectureBadges {
                    tags[lectureBadge, default: []].append(weekNumber)
                }
            }
            for (weekNumber, tutorialBadges) in tutorialTags.enumerated() {
                for tutorialBadge in tutorialBadges {
                    tags[tutorialBadge, default: []].append(weekNumber)
                }
            }
            return tags
        }

    
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
                    var tutorialWeekNumber = -1

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
                                    if self.lectureRecordingLinks.count <= lectureWeekNumber {
                                        self.lectureRecordingLinks.append([])
                                    }
                                    self.lectureRecordingLinks[lectureWeekNumber].append(href)
                                } else {
                                    if self.tutorialRecordingLinks.count <= tutorialWeekNumber {
                                        self.tutorialRecordingLinks.append([])
                                    }
                                    if tutorialWeekNumber >= 0 && tutorialWeekNumber < self.tutorialRecordingLinks.count {
                                        self.tutorialRecordingLinks[tutorialWeekNumber].append(href)
                                    }
                                }
                            }
                        }

                        for badge in try row.select("button.badge") {
                            let badgeText = try badge.text()

                            if isLectureRow {
                                // Check if the lectureTags array has enough inner arrays
                                while self.lectureTags.count <= lectureWeekNumber {
                                    self.lectureTags.append([])
                                }
                                // Append the badgeText to the inner array at index lectureWeekNumber
                                self.lectureTags[lectureWeekNumber].append(badgeText)
                            } else {
                                // Check if the tutorialTags array has enough inner arrays
                                while self.tutorialTags.count <= tutorialWeekNumber {
                                    self.tutorialTags.append([])
                                }
                                // Append the badgeText to the inner array at index tutorialWeekNumber
                                self.tutorialTags[tutorialWeekNumber].append(badgeText)
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

    func scrapeExams(completion: @escaping () -> Void) {
        var request = URLRequest(url: URL(string: "https://studybuddy.co.il/technion/\(id)/exams")!)
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

                    for row in rows {
                        let semesterYear = try row.select("td").first()?.text() ?? ""
                        let examFormLinks = try row.select("td a").array().map { try $0.attr("href") }
                        let solutionLinks = try row.select("td a").array().map { try $0.attr("href") }
                        let recordingLinks = try row.select("td a").array().map { try $0.attr("href") }
                        var subjects: [Int: [String]] = [:]
                        for (index, element) in try row.select("button.badge").array().enumerated() {
                            let subject = try element.text()
                            subjects[index + 1, default: []].append(subject)
                        }

                        // Create an Exam instance with the extracted data
                        let exam = Exam(semesterYear: semesterYear, examFormLinks: examFormLinks, solutionLinks: solutionLinks, recordingLinks: recordingLinks, subjects: subjects)
                        // Add the Exam instance to an array of exams
                        self.exams.append(exam)
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
                let course = Course(
                    id: id,
                    name: name
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
                       isFavorite: isFavorite
                   )
                }
            }
        }
    }
}

let testExams: [Exam] = [
    Exam(
        semesterYear: "2022-2023",
        examFormLinks: ["https://example.com/exam1.pdf", "https://example.com/exam2.pdf"],
        solutionLinks: ["https://example.com/solution1.pdf", "https://example.com/solution2.pdf"],
        recordingLinks: ["https://example.com/recording1.mp4", "https://example.com/recording2.mp4"],
        subjects: [
            1: ["Mathematics", "Physics"],
            2: ["Chemistry", "Biology"]
        ]
    ),
    Exam(
        semesterYear: "2023-2024",
        examFormLinks: ["https://example.com/exam3.pdf", "https://example.com/exam4.pdf"],
        solutionLinks: ["https://example.com/solution3.pdf", "https://example.com/solution4.pdf"],
        recordingLinks: ["https://example.com/recording3.mp4", "https://example.com/recording4.mp4"],
        subjects: [
            1: ["History", "Geography"],
            2: ["Literature", "Language"]
        ]
    )
]


let testCourses = [
    Course(id: "1",
           name: "מתמטיקה",
           lectureTags: [
               ["Lorem ipsum dolor sit amet, consectetur adipiscing"],
               ["גיאומטריה", "טריגונומטריה"],
               ["סטטיסטיקה"]
           ],
           tutorialTags: [
               ["Lorem ipsum dolor sit amet, consectetur adipiscing"],
               ["בעיות גיאומטריה", "בעיות טריגונומטריה"],
               ["בעיות סטטיסטיקה"]
           ],
           lectureLinks: ["https://mathlecturelink1.com", "https://mathlecturelink2.com"],
           lectureRecordingLinks: [["https://mathlecturerecordinglink1.com", "https://mathlecturerecordinglink1.com", "https://mathlecturerecordinglink1.com", "https://mathlecturerecordinglink1.com", "https://mathlecturerecordinglink1.com"], ["https://mathlecturerecordinglink2.com"]],
           tutorialLinks: [],
           tutorialRecordingLinks: [["https://mathtutorialrecordinglink1.com"], ["https://mathtutorialrecordinglink2.com"]]
//           exams: testExams
        ),
    Course(id: "2",
           name: "מתמטיקה",
           lectureTags: [
               ["Lorem ipsum dolor sit amet, consectetur adipiscing"],
               ["גיאומטריה", "טריגונומטריה"],
               ["סטטיסטיקה"]
           ],
           tutorialTags: [
               ["Lorem ipsum dolor sit amet, consectetur adipiscing"],
               ["בעיות גיאומטריה", "בעיות טריגונומטריה"],
               ["בעיות סטטיסטיקה"]
           ],
           lectureLinks: [],
           lectureRecordingLinks: [],
           tutorialLinks: ["https://mathtutoriallink1.com", "https://mathtutoriallink2.com"],
           tutorialRecordingLinks: [["https://mathtutorialrecordinglink1.com"], ["https://mathtutorialrecordinglink2.com"]]
//           exams: testExams
        )
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
