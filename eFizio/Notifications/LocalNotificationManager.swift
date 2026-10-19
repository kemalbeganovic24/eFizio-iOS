import Foundation
import UserNotifications

struct LocalNotificationManager {
    
    static func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Greška pri traženju dozvole za notifikacije: \(error.localizedDescription)")
            }
        }
    }

    static func scheduleReminder(patientName: String, appointmentTimeMillis: Int64) {
        let intervals = [30, 15, 10, 5]
        let appointmentDate = Date(timeIntervalSince1970: TimeInterval(appointmentTimeMillis / 1000))

        for minutes in intervals {
            let reminderDate = appointmentDate.addingTimeInterval(TimeInterval(-minutes * 60))

            if reminderDate > Date() {
                let content = UNMutableNotificationContent()
                content.title = "Uskoro termin!"
                content.body = "Klijent \(patientName) ima termin za \(minutes) minuta."
                content.sound = .default

                let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: reminderDate)
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

                let identifier = "\(patientName)_\(minutes)_\(appointmentTimeMillis)"
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

                UNUserNotificationCenter.current().add(request)
            }
        }
    }
}
