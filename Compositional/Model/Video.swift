//
//  Video.swift
//  Compositional
//
//  Created by Chhailong Sann on 22/5/26.
//
import UIKit

class Video: Hashable {
  var id = UUID()
  var title: String
  var thumbnail: UIImage?
  var lessonCount: Int
  var link: URL?

  init(title: String, thumbnail: UIImage? = nil, lessonCount: Int, link: URL?) {
    self.title = title
    self.thumbnail = thumbnail
    self.lessonCount = lessonCount
    self.link = link
  }
  // 1
  func hash(into hasher: inout Hasher) {
    // 2
    hasher.combine(id)
  }
  // 3
  static func == (lhs: Video, rhs: Video) -> Bool {
    lhs.id == rhs.id
  }
}
