//
//  ContentView.swift
//  PlaceonaApp
//
//  Created by 池上 潤 on 2022/01/05.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        VStack(spacing: 0){
            
            TabView() {
                
                ViewA()
                    .tabItem {Text("a")}
                
                ViewB()
                    .tabItem {Text("b")}
                
                PlaceonaView()
                    .tabItem {Text("Placeona")}
                
            }
            
            VUIView()
        }
        
    }
}


