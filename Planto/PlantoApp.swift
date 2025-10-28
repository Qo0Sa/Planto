//
//  PlantoApp.swift
//  Planto
//
//  Created by Sarah on 06/05/1447 AH.
//

import SwiftUI

@main
struct PlantoApp: App {
    
    init() {
        NotificationManager.shared.requestAuthorization()
    }
    
    var body: some Scene {
        WindowGroup {
            Spalsh()
        }
    }
}
