//
//  KeychainService.swift
//  Charity_App
//
//  Created by Sankeerth V S on 4/15/21.
//

import Foundation
import KeychainSwift

class KeychainService {
    var _localvar = KeychainSwift()
    
    var keyChain: KeychainSwift{
        get {
            return _localvar
        }
        set {
            _localvar = newValue
        }
    }
}
