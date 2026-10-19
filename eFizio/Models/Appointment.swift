import Foundation
import FirebaseFirestore

struct Appointment: Identifiable, Codable {
    @DocumentID var id: String?
    var patientName: String = ""
    var service: String = ""
    var dateStr: String = ""
    var timeStr: String = ""
    var timestampMillis: Int64 = 0
    var priceKM: Int = 0
}

struct HidzamaRecord: Identifiable, Codable {
    @DocumentID var id: String?
    var patientName: String = ""
    var service: String = ""
    var dateStr: String = ""
    var timestampMillis: Int64 = 0
    var cupsCount: Int = 10
    var locations: [String] = []
    var priceKM: Int = 0
}
