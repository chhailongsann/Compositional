//
//  Slider.swift
//  Compositional
//
//  Created by Chhailong Sann on 22/5/26.
//

import Foundation
import UIKit
@MainActor
final class Slider: Hashable {
  static func == (lhs: Slider, rhs: Slider) -> Bool {
    lhs.id == rhs.id
  }
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  let id: UUID
  let image: UIImage
  init(id: UUID = UUID(), image: UIImage) {
    self.id = id
    self.image = image
  }

}

class TopUpAmount: Hashable {
  static func == (lhs: TopUpAmount, rhs: TopUpAmount) -> Bool {
    lhs.id == rhs.id
  }
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }


  let id: UUID
  let title: String
  let amount: Int
  init(id: UUID = UUID(), title: String, amount: Int) {
    self.id = id
    self.title = title
    self.amount = amount
  }
}
