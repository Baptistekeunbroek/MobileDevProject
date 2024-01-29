//
//  Navigation.swift
//  MobileDevProject
//
//  Created by Baptiste Keunebroek on 29/01/2024.
//

import Foundation

import SwiftUI

struct Navigation: View {
    
    
    var body: some View {
        TabView {
            
            
            HomePageView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
                .toolbarBackground(.blue.opacity(0.6), for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
            

            AllActivitiesView()
                .tabItem {
                    Label("All Activities", systemImage: "list.bullet")
                }
            
                .toolbarBackground(.blue.opacity(0.6), for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
            
        }
        .accentColor(.black)
        
    }
    
}

struct Navigation_Previews: PreviewProvider {
    static var previews: some View {
        Navigation()
    }
}
