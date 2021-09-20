//
//  DetailView.swift
//  MapAndContacts
//
//  Created by AnonymFromInternet on 20.09.21.
//

import SwiftUI

import MapKit


struct DetailView: View {
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedPlace: MKPointAnnotation?
    @State private var showingPlaceDetails = false
    
    @State private var locations = [CodableMKPointAnnotation]()
    @State private var centerCoordinate = CLLocationCoordinate2D()
    
    @State private var isMapShowing = false
    
    @State private var isAlertShowing = false
    
    let user: User1
    
    var body: some View {
        
        VStack {
            if user.image != nil {
                if let uiimage = UIImage(data: user.image!) {
                    if let image = Image(uiImage: uiimage) {
                        image
                            .resizable()
                            .scaledToFit()
                    }
                }
            }
            
            VStack {
                Form {
                    Section(header: Text("Name")) {
                        Text(user.name ?? "Unknown Name")
                    }
                    
                    Section(header: Text("Decription")) {
                        
                        Text(user.aboutUser ?? "Unknown Description")
                    }
                    NavigationLink(destination: Map(selectedPlace: $selectedPlace, showingPlaceDetails: $showingPlaceDetails, annotations: locations, centerCoordinate: $centerCoordinate)) {
                        Text("Show Location")
                        
                    }
                }
            }
            .navigationBarTitle(Text("Contact Information"))
            .navigationBarItems(trailing: Button(action: {
                self.deleteContact()
            }, label: {
                Text("Delete this Contact")
                    .foregroundColor(Color(#colorLiteral(red: 1, green: 0.5882352941, blue: 0.6784313725, alpha: 1)))
            }))
            .alert(isPresented: $isAlertShowing) {
                Alert(title: Text("Your Location is equal nil"), message: Text("Please try again later"), dismissButton: .default(Text("Ok")))
            }
        }
        .onAppear(perform: {
            if selectedPlace != nil {
                locationFromData()
            } else {
                self.isAlertShowing = true
            }
        })
        
    }
    func deleteContact() {
        context.delete(user)
        try? self.context.save()
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func locationFromData() {
        
        do {
            selectedPlace = try JSONDecoder().decode(CodableMKPointAnnotation.self, from: user.location!)
        } catch {
            print("Unable to load saved data")
        }
    }
}



struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(user: User1())
    }
}
