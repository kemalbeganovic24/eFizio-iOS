import SwiftUI

struct PatientHistoryView: View {
    @ObservedObject var repository: FizioRepository
    var onBackClick: () -> Void

    @State private var searchQuery: String = ""
    @State private var recordsList: [[String: Any]] = []
    @State private var isLoading: Bool = false

    // Stanja za izmjenu datuma
    @State private var selectedRecordForEdit: [String: Any]? = nil
    @State private var newSelectedDate: Date = Date()
    @State private var showDatePickerAlert: Bool = false

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // Search Field
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Ukucajte ime pacijenta...", text: $searchQuery)
                        .onChange(of: searchQuery) { newValue in
                            performSearch(query: newValue)
                        }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)

                if isLoading {
                    ProgressView()
                    Spacer()
                } else if searchQuery.count >= 2 && recordsList.isEmpty {
                    Text("Nema sačuvanih hidžama za: \(searchQuery)")
                        .foregroundColor(.gray)
                    Spacer()
                } else if !recordsList.isEmpty {
                    
                    // Statistička kartica
                    HStack {
                        VStack(alignment: .leading) {
                            Text(recordsList.first?["patientName"] as? String ?? searchQuery)
                                .font(.headline)
                            Text("Statistika tretmana")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Text("Ukupno hidžama: \(recordsList.count)")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue)
                            .cornerRadius(20)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)

                    // Lista zapisa
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(Array(recordsList.enumerated()), id: \.offset) { index, record in
                                let treatmentNumber = recordsList.count - index

                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        Text("Hidžama #\(treatmentNumber)")
                                            .font(.headline)
                                            .foregroundColor(.blue)
                                        
                                        Spacer()
                                        
                                        
                                        Button(action: {
                                            openDateEditor(for: record)
                                        }) {
                                            HStack(spacing: 4) {
                                                Text(record["dateStr"] as? String ?? "")
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                                Image(systemName: "pencil")
                                                    .font(.caption)
                                            }
                                            .foregroundColor(.blue)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.blue.opacity(0.1))
                                            .cornerRadius(8)
                                        }
                                    }

                                    Text("Usluga: \(record["service"] as? String ?? "Hidžama")")
                                        .font(.subheadline)
                                    
                                    Divider()
                                        .padding(.vertical, 4)

                                    Text("Detalji:")
                                        .font(.subheadline)
                                        .bold()
                                        .foregroundColor(Color(red: 4/255, green: 120/255, blue: 87/255))
                                    
                                    Text("• Broj čašica: \(record["cupsCount"] as? Int ?? 0)")
                                    
                                    let locs = (record["locations"] as? [String])?.joined(separator: ", ") ?? "-"
                                    Text("• Lokacije: \(locs)")
                                }
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(12)
                            }
                        }
                    }
                } else {
                    Spacer()
                }
            }
            .padding()
            .navigationTitle("Karton Pacijenata")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: onBackClick) {
                        Image(systemName: "chevron.left")
                    }
                }
            }
            // Pop-up Sheet za izmjenu datuma
            .sheet(isPresented: $showDatePickerAlert) {
                VStack(spacing: 20) {
                    Text("Uredi Datum Tretmana")
                        .font(.headline)
                        .padding(.top)

                    DatePicker("Novi datum", selection: $newSelectedDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .padding()

                    HStack(spacing: 16) {
                        Button("Otkaži") {
                            showDatePickerAlert = false
                        }
                        .foregroundColor(.red)
                        .padding()

                        Spacer()

                        Button("Spremi Izmjenu") {
                            saveUpdatedDate()
                        }
                        .bold()
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                .presentationDetents([.medium])
            }
        }
    }

    private func performSearch(query: String) {
        if query.count >= 2 {
            isLoading = true
            repository.getHidzamaRecordsByPatient(patientNameQuery: query) { results in
                self.recordsList = results.sorted {
                    (($0["timestampMillis"] as? Int64) ?? 0) > (($1["timestampMillis"] as? Int64) ?? 0)
                }
                self.isLoading = false
            }
        } else {
            recordsList = []
        }
    }

    private func openDateEditor(for record: [String: Any]) {
        self.selectedRecordForEdit = record
        if let millis = record["timestampMillis"] as? Int64 {
            self.newSelectedDate = Date(timeIntervalSince1970: TimeInterval(millis / 1000))
        } else {
            self.newSelectedDate = Date()
        }
        self.showDatePickerAlert = true
    }

    private func saveUpdatedDate() {
        guard let record = selectedRecordForEdit,
              let recordId = record["id"] as? String else { return }

        repository.updateHidzamaRecordDate(recordId: recordId, newDate: newSelectedDate) {
            self.showDatePickerAlert = false
            // Osvježi listu s novim datumom
            self.performSearch(query: self.searchQuery)
        }
    }
}
