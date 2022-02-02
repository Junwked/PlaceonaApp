//
//  PlaceonaAppApp.swift
//  PlaceonaApp
//
//  Created by 池上 潤 on 2022/01/05.
//

import SwiftUI

@main
struct PlaceonaAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(PlaceonaUISystem()) 
        }
    }
}
