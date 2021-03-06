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
    @State private var form="https://forms.gle/3mvpxFanQagBrPw36"
    
    var body:
        some View { //changed from view to scene
        NavigationView{
            VStack{
                Image("Artboard1").resizable().renderingMode(.original).frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: 450, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Spacer()
                Image("Illustration").resizable().renderingMode(.original).frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: 450, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: 450, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                HStack{
                    Text("Enter Zip Code").foregroundColor(.gray).font(.system(size: 25, design: .rounded))
                    Spacer()
                }.frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: 500, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                TextField("Zip Code", text: $textZipCode).keyboardType(.numberPad).font(.system(size: 20, design: .rounded)).frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: 500, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Divider().frame(height:1).background(Color.accentColor).frame(maxWidth: 500)
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
                    Text("SUBMIT").foregroundColor(.white).bold().frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: 500, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).background(Color.accentColor)
                        .cornerRadius(5).font(.system(size: 25, design: .rounded))
                }.alert(isPresented: $showingAlert) {
                    Alert(title: Text("Invalid Zip Code"), message: Text(self.textAlert), dismissButton: .default(Text("OK")))
                  }
                }
                Spacer()
                Text("Found a Bug or Have a Feature Request?").foregroundColor(.gray)
                Button("Click Here", action: feedbackForm)
                    .foregroundColor(.accentColor).frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
            }.padding().navigationTitle("").navigationBarHidden(true)
            
            
          
            }.navigationTitle("").navigationBarHidden(true).navigationViewStyle(StackNavigationViewStyle())
    }
    
    
    func validZipCode(postalCode:String)->Bool{
            let postalcodeRegex = "^[0-9]{5}(-[0-9]{4})?$"
            let pinPredicate = NSPredicate(format: "SELF MATCHES %@", postalcodeRegex)
            let bool = pinPredicate.evaluate(with: postalCode) as Bool
            return bool
        }
    
    func feedbackForm(){
        UIApplication.shared.open(URL(string: form)!)
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
