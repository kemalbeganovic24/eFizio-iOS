import SwiftUI

struct BookingView: View {
    @ObservedObject var repository: FizioRepository
    var onBooked: () -> Void
    var onNavigateToPatientHistory: () -> Void

    @State private var patientName: String = ""
    @State private var selectedDate: Date = Date()
    @State private var showDatePicker: Bool = false
    
    @State private var startTimeSlot: String? = "10:00"
    @State private var endTimeSlot: String? = "11:00"
    
    @State private var selectedServices: [String: Int] = [:]
    
    @State private var cupsCount: Int = 10
    private let availableLocations = ["Leđa", "Glava", "Vrat", "Noge", "Ruke", "Lumbarni dio"]
    @State private var selectedLocations: Set<String> = ["Leđa"]

    let servicePrices: [String: Int] = [
        "Masaža leđa": 45,
        "Relax masaža čitavog tijela": 60,
        "Sportska masaža čitavog tijela": 80,
        "Antistres masaža glave i leđa": 50,
        "Masaza lica": 30,
        "Masaza stopala": 25,
        "Gold luxury masaža 24k (lice+cijelo tijelo)": 90,
        "Compex Sp6": 30,
        "Tens": 20,
        "Kinesi tape 10": 10,
        "Kinesi tape 20": 20,
        "Kinesi tape 30": 30,
        "Hidžama": 50,
        "Elektroterapija TENS": 30,
        "Kineziterapija kucne posjete": 60,
        "REBOOT One terapija": 40
    ]

    let timeSlots = [
        "09:00", "09:15", "09:30", "09:45", "10:00",
        "10:15", "10:30", "10:45", "11:00",
        "11:15", "11:30", "11:45", "12:00",
        "12:15", "12:30", "12:45", "13:00",
        "13:15", "13:30", "13:45", "14:00",
        "14:15", "14:30", "14:45", "15:00",
        "15:15", "15:30", "15:45", "16:00",
        "16:15", "16:30", "16:45", "17:00",
        "17:15", "17:30", "17:45", "18:00",
        "18:15", "18:30", "18:45", "19:00",
        "19:15", "19:30", "19:45", "20:00",
        "20:15", "20:30", "20:45", "21:00",
        "21:15", "21:30", "21:45", "22:00"
    ]

    var totalCost: Int {
        selectedServices.values.reduce(0, +)
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy."
        return formatter.string(from: selectedDate)
    }

    var timeRangeStr: String {
        if let start = startTimeSlot, let end = endTimeSlot {
            return "\(start) - \(end)"
        }
        return startTimeSlot ?? ""
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Zakaži Novi Termin")
                    .font(.title2)
                    .bold()

                TextField("Ime i prezime klijenta", text: $patientName)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)

                DatePicker("Odabrani datum", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)

                Text("Vrijeme: \(timeRangeStr)")
                    .font(.headline)
                    .foregroundColor(.blue)

                // Popravljen Grid za Termine bez fiksnog preklapanja
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    ForEach(timeSlots, id: \.self) { slot in
                        let isSelected = (slot == startTimeSlot || slot == endTimeSlot)
                        Text(slot)
                            .font(.system(size: 14, weight: isSelected ? .bold : .regular))
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .background(isSelected ? Color.blue : Color(.secondarySystemBackground))
                            .foregroundColor(isSelected ? .white : .primary)
                            .cornerRadius(10)
                            .onTapGesture {
                                if startTimeSlot == nil || endTimeSlot != nil {
                                    startTimeSlot = slot
                                    endTimeSlot = nil
                                } else {
                                    endTimeSlot = slot
                                }
                            }
                    }
                }

                Divider()
                    .padding(.vertical, 8)

                Text("Odaberi usluge:")
                    .font(.headline)

                ForEach(servicePrices.sorted(by: <), id: \.key) { service, price in
                    let isChecked = selectedServices.keys.contains(service)

                    VStack {
                        HStack {
                            Text(service)
                            Spacer()
                            Text("\(price) KM")
                                .bold()
                        }
                        .padding()
                        .background(isChecked ? Color.blue.opacity(0.1) : Color(.secondarySystemBackground))
                        .cornerRadius(10)
                        .onTapGesture {
                            if isChecked {
                                selectedServices.removeValue(forKey: service)
                            } else {
                                selectedServices[service] = price
                            }
                        }

                        // Opcije za Hidžamu
                        if service == "Hidžama" && isChecked {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Postavke Hidžame:")
                                    .bold()
                                    .foregroundColor(.blue)

                                HStack {
                                    Text("Broj čašica:")
                                    Spacer()
                                    Button("-") { if cupsCount > 1 { cupsCount -= 1 } }
                                        .buttonStyle(.bordered)
                                    Text("\(cupsCount)")
                                        .bold()
                                    Button("+") { cupsCount += 1 }
                                        .buttonStyle(.bordered)
                                }

                                Text("Lokacije:")
                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 6) {
                                    ForEach(availableLocations, id: \.self) { loc in
                                        let isLocSelected = selectedLocations.contains(loc)
                                        Text(loc)
                                            .font(.caption)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 6)
                                            .background(isLocSelected ? Color.blue : Color.gray.opacity(0.3))
                                            .foregroundColor(isLocSelected ? .white : .primary)
                                            .cornerRadius(15)
                                            .onTapGesture {
                                                if isLocSelected {
                                                    selectedLocations.remove(loc)
                                                } else {
                                                    selectedLocations.insert(loc)
                                                }
                                            }
                                    }
                                }
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                }

                // Ukupno
                HStack {
                    Text("Ukupno za naplatiti:")
                        .bold()
                    Spacer()
                    Text("\(totalCost) KM")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.blue)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)

                // Dugme Zakazivanje
                let canSubmit = !patientName.isEmpty && !selectedServices.isEmpty && startTimeSlot != nil

                Button(action: saveAppointment) {
                    Text("Spremi Termin")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(canSubmit ? Color.blue : Color.gray)
                        .cornerRadius(16)
                }
                .disabled(!canSubmit)
                .padding(.bottom, 24)
            }
            .padding()
        }
    }

    private func saveAppointment() {
        var calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        
        if let time = startTimeSlot {
            let parts = time.split(separator: ":")
            if parts.count == 2, let hour = Int(parts[0]), let minute = Int(parts[1]) {
                components.hour = hour
                components.minute = minute
            }
        }

        let exactDate = calendar.date(from: components) ?? selectedDate
        let timestampMillis = Int64(exactDate.timeIntervalSince1970 * 1000)

        let newAppt = Appointment(
            patientName: patientName,
            service: selectedServices.keys.joined(separator: ", "),
            dateStr: formattedDate,
            timeStr: timeRangeStr,
            timestampMillis: timestampMillis,
            priceKM: totalCost
        )

        let isHidzamaSelected = selectedServices.keys.contains("Hidžama")

        repository.addAppointmentWithHidzama(
            appointment: newAppt,
            isHidzama: isHidzamaSelected,
            cupsCount: cupsCount,
            locations: Array(selectedLocations)
        ) {
            LocalNotificationManager.scheduleReminder(patientName: patientName, appointmentTimeMillis: timestampMillis)
            patientName = ""
            selectedServices.removeAll()
            onBooked()
        }
    }
}
