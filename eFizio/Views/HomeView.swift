import SwiftUI

struct HomeView: View {
    @ObservedObject var repository: FizioRepository
    @Binding var isDarkMode: Bool

    @State private var searchText: String = ""

    var filteredAppointments: [Appointment] {
        if searchText.isEmpty {
            return repository.appointments
        } else {
            return repository.appointments.filter {
                $0.patientName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            // Top Banner
            HStack {
                VStack(alignment: .leading) {
                    Text("Fizioterapeut Ajdin Islamović")
                        .font(.headline)
                        .foregroundColor(Color(red: 76/255, green: 175/255, blue: 80/255))
                }
                Spacer()
                Button(action: { isDarkMode.toggle() }) {
                    Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                        .padding(10)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                        .foregroundColor(isDarkMode ? .yellow : .white)
                }
            }
            .padding()
            .frame(height: 90)
            .background(Color(red: 31/255, green: 41/255, blue: 55/255))
            .cornerRadius(20)

            Text("Termini")
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)

            if filteredAppointments.isEmpty {
                Spacer()
                Text("Nema zakazanih termina.")
                    .foregroundColor(.gray)
                Spacer()
            } else {
                List {
                    ForEach(filteredAppointments) { appt in
                        AppointmentRow(appointment: appt) {
                            if let id = appt.id {
                                repository.deleteAppointment(appointmentId: id)
                            }
                        }
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
            }
        }
        .padding()
        .onAppear {
            repository.listenToAppointments()
        }
    }
}

struct AppointmentRow: View {
    let appointment: Appointment
    let onDelete: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(appointment.patientName)
                    .font(.headline)
                Text(appointment.service)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                HStack {
                    Image(systemName: "clock")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(appointment.dateStr) - \(appointment.timeStr)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                Text("Ukupno: \(appointment.priceKM) KM")
                    .font(.footnote)
                    .fontWeight(.semibold)
            }

            Spacer()

            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}
