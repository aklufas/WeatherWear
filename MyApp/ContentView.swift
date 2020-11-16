//
//  ContentView.swift
//  MyApp
//
//  Created by Muhammad Farooq on 11/16/20.
//

import SwiftUI

struct ContentView: View {
    
    @State private var goToMainView=false
    
    var body: some View {
        NavigationView{
        
            NavigationLink(destination: MainView(), isActive:$goToMainView){
                VStack{
            Image("icon").resizable().renderingMode(.original).frame(width: 200, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Text("Weather Wear").bold().font(.system(size: 25)).foregroundColor(.accentColor)
            }
        }.onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.goToMainView=true
            }
        }
            .navigationTitle("").navigationBarHidden(true)
        }.navigationTitle("").navigationBarHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
