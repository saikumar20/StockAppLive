//
//  HapticManager.swift
//  StockAppLive
//
//  Created by Test on 29/06/25.
//

import Foundation
import UIKit

final class HapticManager {
    
    static let shared =  HapticManager()
    
    private init() {}
    
    func vibrationWhileSelecting() {
        
        let obj = UISelectionFeedbackGenerator()
        obj.prepare()
        obj.selectionChanged()
        
    }
    
    func vibrate(type : UINotificationFeedbackGenerator.FeedbackType) {
        
        let obj = UINotificationFeedbackGenerator()
        obj.prepare()
        obj.notificationOccurred(type)
    }
}
