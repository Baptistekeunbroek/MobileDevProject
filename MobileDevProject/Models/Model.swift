import Foundation

struct Record: Codable {
    var id: String
    var createdTime: String
    var fields: Fields
}

struct Fields: Codable {
    var Start: String
    var Location: String
    var Notes: String?
    var Activity: String
    var End: String
    var `Type`: String
    var Speaker: [String]?

    var startDate: String {
        formatDate(from: Start)
    }

    var startTime: String {
        formatTime(from: Start)
    }

    var endTime: String {
        formatTime(from: End)
    }

    private func formatDate(from dateTimeString: String) -> String {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate, .withDashSeparatorInDate]
        guard let date = dateFormatter.date(from: dateTimeString) else { return "" }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"
        return outputFormatter.string(from: date)
    }

    private func formatTime(from dateTimeString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        guard let date = isoFormatter.date(from: dateTimeString) else { return "" }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "HH:mm"
        return outputFormatter.string(from: date)
    }
}

struct Speaker: Decodable {
    var id: String
    var name: String
    var company: String
    var role: String
    var email: String?
    var phone: String?
    var confirmed: Bool
}

struct Response: Codable {
    var records: [Record]
}
