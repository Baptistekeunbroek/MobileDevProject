//
//  ContentView.swift
//  MobileDevProject
//
//  Created by Baptiste Keunebroek on 22/01/2024.
//

import SwiftUI

struct TalkRowView: View {
    var talk: Fields
    @State private var isExpanded: Bool = false
    @State private var speakers: [Speaker] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(talk.Activity)
                .font(.headline)
                .foregroundColor(.blue)
                .onTapGesture {
                    withAnimation {
                        self.isExpanded.toggle()
                    }
                }

            HStack {
                Image(systemName: "location.circle")
                    .foregroundColor(.green)
                Text(talk.Location)
                    .font(.subheadline)
            }

           

            HStack {
                Text("Date: \(talk.startDate)")
                Spacer()
                Text("Start Time: \(talk.startTime)")
                Spacer()
                Text("End Time: \(talk.endTime)")
            }
            .font(.footnote)

            if isExpanded {
                
                if let notes = talk.Notes, !notes.isEmpty {
                    Text(notes)
                        .font(.subheadline)
                                        }
                
                Text("Type: \(talk.Type)")
                    .font(.subheadline)
                         
                if let speakerIds = talk.Speaker, !speakerIds.isEmpty {
                               ForEach(speakers, id: \.id) { speaker in
                                   Text(speaker.name)
                                       .font(.subheadline)
                               }
                           } else {
                               Text("No speakers available")
                                   .font(.subheadline)
                           }

                       }
            
                   }
                   .padding()
                   .background(Color.white.opacity(0.7))
                   .cornerRadius(10)
                   .shadow(color: .gray, radius: 2, x: 0, y: 2)
                   .padding([.top, .horizontal])
               }
    private func loadSpeakerDetails() {
            if let speakerIds = talk.Speaker, !speakerIds.isEmpty {
                NetworkManager().fetchSpeakerDetails(ids: speakerIds) { fetchedSpeakers in
                    self.speakers = fetchedSpeakers
                }
            }
        }
    }
           





struct AllActivitiesView: View {
    @State private var allFields: [Fields] = []

    private var activitiesOnFirstDate: [Fields] {
        allFields.filter { startDate(from: $0.Start) == "2024-02-08" }
                 .sorted { $0.Start < $1.Start }
    }

    private var activitiesOnSecondDate: [Fields] {
        allFields.filter { startDate(from: $0.Start) == "2024-02-09" }
                 .sorted { $0.Start < $1.Start }
    }

    var body: some View {
        ZStack {
            Color.blue.opacity(0.3).edgesIgnoringSafeArea(.all)
            ScrollView {
                Text("Day One")
                    .font(.title)
                Section(header: Text("2024-02-08")) {
                    ForEach(activitiesOnFirstDate, id: \.Activity) { talk in
                        TalkRowView(talk: talk)
                    }
                }
                
                Text("Day Two")
                    .font(.title)
                Section(header: Text("2024-02-09")) {
                    ForEach(activitiesOnSecondDate, id: \.Activity) { talk in
                        TalkRowView(talk: talk)
                    }
                }
            }
            .padding(.top, 0)
            .onAppear {
                NetworkManager().fetchTalks { fetchedTalks in
                    self.allFields = fetchedTalks
                }
            }
        }
    }

    private func startDate(from dateTimeString: String) -> String {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate, .withDashSeparatorInDate]
        guard let date = dateFormatter.date(from: dateTimeString) else { return "" }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"
        return outputFormatter.string(from: date)
    }
}

struct AllActivitiesView_Previews: PreviewProvider {
    static var previews: some View {
        AllActivitiesView()
    }
}





struct HomePageView: View {
    @State private var fields: [Fields] = []
    @State private var todayActivities: [Fields] = []
    @State private var nextActivityDate: String = ""

    var body: some View {
        ZStack {
            Color.blue.opacity(0.3).edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 10){
                    Text("Security Event")
                        .font(.title)
                    
                    
                        if todayActivities.isEmpty {
                            VStack(spacing: 10) {
                                Text("No activities today")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                
                                Text("Today's date: \(formattedTodayDate())")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                
                                if !nextActivityDate.isEmpty {
                                    Text("Next activity on \(nextActivityDate)")
                                        .font(.headline)
                                        .foregroundColor(.blue)
                                } else {
                                    Text("No upcoming activities")
                                        .font(.headline)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                        } else {
                            activityList
                        }
                }
            }
            .onAppear(perform: fetchTodayTalks)
        }
    }

    private var activityList: some View {
            Section(header: Text("Today's Program")
                        .font(.title2)
                        .foregroundColor(.green)) {
                ForEach(todayActivities, id: \.Activity) { talk in
                    TalkRowView(talk: talk)
                    .padding(.bottom, 5)
                }
            }
        }
    
    
    private func fetchTodayTalks() {
        NetworkManager().fetchTalks { fetchedTalks in
            self.fields = fetchedTalks
            self.todayActivities = self.fields.filter { isToday(dateString: $0.Start) }
                .sorted { $0.Start < $1.Start }

            if self.todayActivities.isEmpty {
                determineNextActivityDate()
            }
        }
    }

    private func determineNextActivityDate() {
        let now = Date()
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds, .withTimeZone]

        let futureActivities = fields.filter {
            guard let activityDate = isoFormatter.date(from: $0.Start) else { return false }
            print("Activity Date: \(activityDate), Now: \(now)")
            return activityDate > now
        }

        print("Future Activities: \(futureActivities)")

        if let nextActivity = futureActivities.sorted(by: { $0.Start < $1.Start }).first {
            nextActivityDate = formatDateTimeString(nextActivity.Start)
            print("Next Activity Date: \(nextActivityDate)")
        }
    }




        private func formatDateTimeString(_ dateTimeString: String) -> String {
            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.formatOptions = [.withInternetDateTime]

            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "EEEE, MMM d, yyyy 'at' h:mm a"

            if let date = isoFormatter.date(from: dateTimeString) {
                return displayFormatter.string(from: date)
            } else {
                return ""
            }
        }

    private func isToday(dateString: String) -> Bool {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds, .withTimeZone]
        
        guard let date = isoFormatter.date(from: dateString) else { return false }
        
        /*
         // Mock current date for testing
        var testCurrentDateComponents = DateComponents()
        testCurrentDateComponents.year = 2024
        testCurrentDateComponents.month = 2
        testCurrentDateComponents.day = 8
        let testCurrentDate = Calendar.current.date(from: testCurrentDateComponents)!
        */
        return Calendar.current.isDate(date, inSameDayAs: Date()) //Change Date() with testCurrentDate to test
    }


    private func formattedTodayDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: Date())
    }
}


struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
