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
    @State private var intTemperature = 0
    @State private var form="https://forms.gle/3mvpxFanQagBrPw36"
    
    
    @State var cityName:String
    @State var zipCode:String
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView{
            
            VStack{
                ZStack{
                    Image("Bg").resizable().renderingMode(.original).edgesIgnoringSafeArea(.top)
                    //.frame(height:200) //just added
                    VStack(spacing: 5){
                        Spacer().frame(height: 30)
                        Button(action:{
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Image("Back").resizable().renderingMode(.original).frame(width: 20, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).padding([.leading,.top])
                            
                        }.frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                        
                        //City Name
                        Text(cityName).foregroundColor(.white).bold().font(.system(size: 35, design: .rounded))
                        
                        
                        //Weather Icon + Temperature
                        HStack(alignment: .center, spacing: 0){
                            Image(self.icon).resizable().renderingMode(.original).frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: .top)
                            Text(self.textTemperature + "˚F").foregroundColor(.white).bold().font(.system(size: 55, design: .rounded))

                        }.frame(height: 50)
                            Text(self.textDescription).foregroundColor(.white)
                                .font(.system(size: 20, design: .rounded))
                        
                        Spacer().frame(height: 40)
                        
                    }
                    
                }.frame(height:200).onAppear{
                    self.getTemperature(zipcode: self.zipCode)
                }
                
                //coat scroll
                ScrollView(.vertical){
                    Spacer().frame(height: 30)
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(coatSelection(temp: self.intTemperature), id: \.self) {
            
                            Image("ci\($0)").resizable().renderingMode(.original).frame(width: 130, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            Text(coatConversion(coat: "\($0)"))

                    }
                 }
                }
                Spacer()
                Text("Found a Bug or Have a Feature Request?").foregroundColor(.gray)
                Button("Click Here", action: feedbackForm)
                    .foregroundColor(.accentColor).frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }.navigationTitle("").navigationBarHidden(true)
            
            
        }.navigationTitle("").navigationBarHidden(true)
    }
    
    //need to choose the coats 
    func coatSelection(temp: Int) -> [Int] {
        if temp < 30{
            return [11,12]
        }
        else if temp < 40{
            return [10,11,12]
        }
        else if temp < 50{
            return [6,7,8,9]
        }
        else if temp < 60{
            return [3,4,5,6]
        }
        else if temp < 70{
            return [1,2]
        }
        else{
            return [1]
        }
    }
    
    func coatConversion(coat: String) -> String{
        return "hello"
    }
    
    func feedbackForm(){
        UIApplication.shared.open(URL(string: form)!)
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
                                //use self.newTemp or new variable?
                                self.intTemperature = newTemp
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
