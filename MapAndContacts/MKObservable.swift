//
//  MKObservable.swift
//  MapAndContacts
//
//  Created by AnonymFromInternet on 20.09.21.
//

import SwiftUI
import MapKit


extension MKPointAnnotation: ObservableObject {
    
    public var wrappedTitle: String {
        
        get {
            self.title ?? ""
        }
        
        set {
            title = newValue
        }
    }
    
    public var wrappedSubtitle: String {
        
        get {
            self.subtitle ?? ""
        }
        
        set {
            subtitle = newValue
        }
    }
}
