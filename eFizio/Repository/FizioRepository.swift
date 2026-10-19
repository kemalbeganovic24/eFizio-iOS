import Foundation
import Combine
import FirebaseFirestore

class FizioRepository: ObservableObject {
    private let db = Firestore.firestore()
    
    @Published var appointments: [Appointment] = []
    private var listenerRegistration: ListenerRegistration?

    deinit {
        listenerRegistration?.remove()
    }

    // 1. ZAKAŽI TERMIN + AUTOMATSKI KARTON AKO JE HIDŽAMA
    func addAppointmentWithHidzama(
        appointment: Appointment,
        isHidzama: Bool,
        cupsCount: Int,
        locations: [String],
        onComplete: @escaping () -> Void
    ) {
        let apptRef = db.collection("appointments").document()
        var newAppt = appointment
        newAppt.id = apptRef.documentID

        do {
            try apptRef.setData(from: newAppt) { [weak self] error in
                guard error == nil else { return }

                if isHidzama {
                    let hidzamaZapis: [String: Any] = [
                        "patientName": appointment.patientName,
                        "dateStr": appointment.dateStr,
                        "timestampMillis": appointment.timestampMillis,
                        "cupsCount": cupsCount,
                        "locations": locations,
                        "service": appointment.service,
                        "priceKM": appointment.priceKM
                    ]

                    self?.db.collection("hidzama_records").addDocument(data: hidzamaZapis) { _ in
                        onComplete()
                    }
                } else {
                    onComplete()
                }
            }
        } catch {
            print("Greška pri spremanju: \(error)")
        }
    }

    // 2. SLUŠANJE TERMINA UŽIVO
    func listenToAppointments() {
        listenerRegistration = db.collection("appointments")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let documents = snapshot?.documents, error == nil else {
                    self?.appointments = []
                    return
                }

                self?.appointments = documents.compactMap { doc in
                    try? doc.data(as: Appointment.self)
                }
            }
    }

    // 3. BRISANJE TERMINA
    func deleteAppointment(appointmentId: String, onComplete: (() -> Void)? = nil) {
        db.collection("appointments").document(appointmentId).delete { _ in
            onComplete?()
        }
    }

    // 4. PRETRAGA KARTONA
    func getHidzamaRecordsByPatient(patientNameQuery: String, onResult: @escaping ([[String: Any]]) -> Void) {
        db.collection("hidzama_records").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                onResult([])
                return
            }

            let list = documents.compactMap { doc -> [String: Any]? in
                var data = doc.data()
                data["id"] = doc.documentID
                return data
            }.filter { dict in
                let name = dict["patientName"] as? String ?? ""
                return name.localizedCaseInsensitiveContains(patientNameQuery)
            }

            onResult(list)
        }
    }
    func updateHidzamaRecordDate(recordId: String, newDate: Date, onComplete: @escaping () -> Void) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy."
        let dateStr = formatter.string(from: newDate)
        let timestampMillis = Int64(newDate.timeIntervalSince1970 * 1000)

        db.collection("hidzama_records").document(recordId).updateData([
            "dateStr": dateStr,
            "timestampMillis": timestampMillis
        ]) { error in
            if let error = error {
                print("Greška pri ažuriranju datuma: \(error.localizedDescription)")
            } else {
                onComplete()
            }
        }
    }
}
