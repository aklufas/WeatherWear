//
//  InformationView.swift
//  MyApp
//
//  Created by Muhammad Farooq on 11/16/20.
//

import SwiftUI
import UIKit
import Alamofire
import SwiftyJSON

struct InformationView: View {
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State private var textTemperature=""
    @State private var textDescription=""
    @State private var icon=""
    
    @State var cityName:String
    @State var zipCode:String
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView{
           
            VStack{
                ZStack{
                    Image("Bg").resizable().renderingMode(.original).edgesIgnoringSafeArea(.top)
                    VStack{
                        Button(action:{
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Image("Back").resizable().renderingMode(.original).frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).padding([.leading,.top])
                            
                        }.frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                        Text(cityName).foregroundColor(.white).bold().font(.system(size: 25))
                        Text(self.textDescription).foregroundColor(.white).font(.system(size: 15))
                        HStack{
                            Image(self.icon).resizable().renderingMode(.original).frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            Text(self.textTemperature).foregroundColor(.white).bold().font(.system(size: 55))
                        }
                        Spacer()
                    }
                    
                }.frame(height:200).onAppear{
                    self.getTemperature(zipcode: self.zipCode)
                }
                ScrollView(.vertical){
                    LazyVGrid(columns: columns, spacing: 20) {
                ForEach((1...11), id: \.self) {
                    Image("ci\($0)").resizable().renderingMode(.original).frame(width: 130, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }
                }
                }
                Spacer()
            }.navigationTitle("").navigationBarHidden(true)
            
        }.navigationTitle("").navigationBarHidden(true)
    }
    func getTemperature(zipcode:String) {
        // 1
        let request = AF.request("https://api.openweathermap.org/data/2.5/weather?zip=\(zipcode),us&appid=fcb8c95d8335d44d6a013e1b3acaf585")
        // 2
        request.responseJSON { response in
            switch response.result {
            case let .success(value):
                print(value)
                if let JSON = value as? [String: Any] {
                    if let main = JSON["main"] as? NSDictionary {
                            if let temperature = main["temp"] as? Double {
                                let newTemp:Int = Int((temperature - 273.15) * 1.8 + 32)
                                self.textTemperature=String(newTemp)
                                

                            }
//                        if let kelvinTemp = main["temp"] as? Double {
//                            let celsiusTemp = kelvinTemp - 273.15
//                            self.textTemperature = String(format: "%.0f", celsiusTemp)
//                        }
                            
                        }

                   
                    if let items = JSON["weather"] as? [Any]{
                       for item in items as! [[String : Any]]{
                        let description = (item["description"] ?? "") as! String
                        let icon = (item["icon"] ?? "") as! String
                        self.icon=icon
                        self.textDescription=description
                        
                       }
                    }
                   
                }
               
    
            case let .failure(error):
                print(error)
            }
            
        }
    }
}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView(cityName: "",zipCode:"")
    }
}
