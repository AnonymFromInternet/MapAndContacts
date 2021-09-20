//
//  LocationAddView.swift
//  MapAndContacts
//
//  Created by AnonymFromInternet on 20.09.21.
//

import SwiftUI

import MapKit


struct LocationInAddView: View {
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode
    @Binding var isViewForMapShowing: Bool
    @ObservedObject var placeMark: MKPointAnnotation
    
    
    
    var body: some View {
        
        NavigationView {
            Form {
                Section {
                    TextField("Place Name", text: $placeMark.wrappedTitle)
                    TextField("Description", text: $placeMark.wrappedSubtitle)
                }
            }
            .navigationBarTitle(Text("About this Place"))
            .navigationBarItems(trailing: Button("Done") {
                self.isViewForMapShowing = false
                self.presentationMode.wrappedValue.dismiss()
                
                try? context.save()
            })
        }
        
        
    }
}
struct LocationInAddView_Previews: PreviewProvider {
    static var previews: some View {
        LocationInAddView(isViewForMapShowing: .constant(true), placeMark: MKPointAnnotation.example)
    }
}
