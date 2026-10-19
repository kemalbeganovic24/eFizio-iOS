import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        LocalNotificationManager.requestPermission()
        return true
    }
}

@main
struct eFizioApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var repository = FizioRepository()
    @State private var isDarkMode: Bool = false
    @State private var selectedTab: Int = 0

    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                HomeView(repository: repository, isDarkMode: $isDarkMode)
                    .tabItem {
                        Label("Početna", systemImage: "house.fill")
                    }
                    .tag(0)

                BookingView(
                    repository: repository,
                    onBooked: { selectedTab = 0 },
                    onNavigateToPatientHistory: { selectedTab = 2 }
                )
                .tabItem {
                    Label("Zakaži", systemImage: "calendar")
                }
                .tag(1)

                PatientHistoryView(
                    repository: repository,
                    onBackClick: { selectedTab = 0 }
                )
                .tabItem {
                    Label("Karton", systemImage: "doc.text.fill")
                }
                .tag(2)
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
