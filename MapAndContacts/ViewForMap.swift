//
//  ViewForMap.swift
//  MapAndContacts
//
//  Created by AnonymFromInternet on 20.09.21.
//

import SwiftUI

import MapKit

struct ViewForMap: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode
    
    
    @State private var selectedPlace: MKPointAnnotation?
    @State private var showingPlaceDetails = false
    @State private var locations = [CodableMKPointAnnotation]()
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var isLocationAddViewShowing = false
    @State var isThisViewShowing: Bool
    @Binding var user: User1?
    
    var body: some View {
        
        if isThisViewShowing {
            ZStack {
                Map(selectedPlace: $selectedPlace, showingPlaceDetails: $showingPlaceDetails, annotations: locations, centerCoordinate: $centerCoordinate)
                    .edgesIgnoringSafeArea(.all)
                Circle()
                    .fill(Color.blue)
                    .opacity(0.36)
                    .frame(width: 36, height: 36)
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            
                            let newLocation = CodableMKPointAnnotation()
                            newLocation.coordinate = self.centerCoordinate
                            newLocation.title = ""
                            self.locations.append(newLocation)
                            self.selectedPlace = newLocation
                            self.isLocationAddViewShowing = true
                        }, label: {
                            Image(systemName: "plus")
                        })
                        .padding()
                        .background(Color.black.opacity(0.36))
                        .foregroundColor(.white)
                        .font(.title)
                        .clipShape(Circle())
                        .padding(.trailing)
                    }
                }
                .sheet(isPresented: $isLocationAddViewShowing, onDismiss: {
                    self.isThisViewShowing = false
                }, content: {
                    LocationInAddView(isViewForMapShowing: $isThisViewShowing, placeMark: self.selectedPlace!).environment(\.managedObjectContext, self.context)// Указать параметр ондисмис, внутри которого вызывается функция сохранения данных
                })
            }
        } else {
            Text("Loading")
                .foregroundColor(Color(#colorLiteral(red: 1, green: 0.5882352941, blue: 0.6784313725, alpha: 1)))
                .onAppear(perform: {
                    self.presentationMode.wrappedValue.dismiss()
                })
        }
    }
    
    func location() {
        do {
            let data = try JSONEncoder().encode(self.selectedPlace as! CodableMKPointAnnotation)
            user?.location = data
            try? self.context.save()
        } catch {
            print("Cannot save Location")
        }
    }
}

