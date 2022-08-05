//
//  Alert.swift
//  Book
//
//  Created by Finley on 2022/08/05.
//

import UIKit

protocol AlertActionConvertible {
    var title: String { get }
    var style: UIAlertAction.Style { get }
}
