//
//  MainView.swift
//  MyApp
//
//  Created by Muhammad Farooq on 11/16/20.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct MainView: View {
    
    @State private var textZipCode=""
    @State private var showingAlert = false
    @State private var textAlert=""
    @State private var goToInformationView=false
    @State private var city=""
    
    var body: some View {
        NavigationView{
            VStack{
                Image("Artboard1").resizable().renderingMode(.original).frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Image("Illustration").resizable().renderingMode(.original).frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                HStack{
                Text("Enter Zip Code").foregroundColor(.gray)
                    Spacer()
                }
                TextField("Zip Code", text: $textZipCode).keyboardType(.numberPad)
                Divider().frame(height:1).background(Color.accentColor)
                NavigationLink(destination:InformationView(cityName: self.city,zipCode: self.textZipCode),isActive: $goToInformationView){
                Button(action:{
 
                        if validZipCode(postalCode: self.textZipCode) {
                            //Correct zip code
                            loadView(zipcode: self.textZipCode)
                        } else {
                            self.textAlert="Please enter a zip code within the US."
                            self.showingAlert=true
                        }
                    
                }) {
                    Text("SUBMIT").foregroundColor(.white).bold().frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).background(Color.accentColor).cornerRadius(5)
                }.alert(isPresented: $showingAlert) {
                    Alert(title: Text("Ooops"), message: Text(self.textAlert), dismissButton: .default(Text("Got it!")))
                }
                }
            }.padding().navigationTitle("").navigationBarHidden(true)
        }.navigationTitle("").navigationBarHidden(true)
    }
    func validZipCode(postalCode:String)->Bool{
            let postalcodeRegex = "^[0-9]{5}(-[0-9]{4})?$"
            let pinPredicate = NSPredicate(format: "SELF MATCHES %@", postalcodeRegex)
            let bool = pinPredicate.evaluate(with: postalCode) as Bool
            return bool
        }
    func loadView(zipcode:String) {
        // 1
        let request = AF.request("https://ziptasticapi.com/"+zipcode)
        // 2
        request.responseJSON { response in
            switch response.result {
            case let .success(value):
                let json = JSON(value)
                if let country = json["country"].string {
                    if country=="US" {
                        if let city = json["city"].string {
                            //do something
                            self.city=city
                            self.goToInformationView=true
                        }
                    } else {
                        self.textAlert="Wrong zip code."
                        self.showingAlert=true
                    }
                } else {
                    self.textAlert="Wrong zip code."
                    self.showingAlert=true
                }
               
    
            case let .failure(error):
                print(error)
            }
            
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
