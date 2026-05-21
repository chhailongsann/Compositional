//
//  BXPageControl.swift
//  Compositional
//
//  Created by Chhailong Sann on 15/5/26.
//

import UIKit
import BXAnchor

open class BXPageControl: UIView {

  enum Alignment {
    case leading
    case trailing
    case center
  }

  enum Style {
    case dot
    case snake
  }


  // MARK: Properties
  private var leadingConstraint: NSLayoutConstraint?
  private var trailingConstraint: NSLayoutConstraint?
  private var centerConstraint: NSLayoutConstraint?
  private var widthConstraint: NSLayoutConstraint?
  private var stackViewWidthConstraint: NSLayoutConstraint?
  private var indicatorWidthConstraints: [Int: NSLayoutConstraint] = [:]
  private var stackViewYOffset: CGFloat = 0


  private lazy var containerVisualEffectView = VisualEffectContainerView().config {
    $0.layer.cornerRadius = padding + (size / 2)
  }

  private lazy var stackView = UIStackView().config {
    $0.spacing = spacing
    $0.axis = .horizontal
    $0.layoutMargins = .zero
  }

  var currentPageIndicatorTintColor: UIColor = .label {
    didSet {
      let dots = stackView.arrangedSubviews
      dots.forEach {
        $0.backgroundColor = $0.tag == self.currentPage ? currentPageIndicatorTintColor : pageIndicatorTintColor
      }
    }
  }

  private var pageIndicatorTintColor: UIColor = .secondaryLabel.withAlphaComponent(0.3) {
    didSet {
      let dots = stackView.arrangedSubviews
      dots.forEach {
        $0.backgroundColor = $0.tag == self.currentPage ? currentPageIndicatorTintColor : pageIndicatorTintColor
      }
    }
  }

  private var spacing: CGFloat = 6 {
    didSet {
      stackView.spacing = spacing
      setCurrentPage(self.currentPage)
    }
  }
  private var currentPageWidth: CGFloat {
    get {
      switch style {
          case .dot: return size
        default: return size * 2 + spacing
      }
    }
  }
  /// Store views in collection so we don't have to iterate through stackview subview.
  private var indicatorCollections: [Int: IndicatorView] = [:]

  /// The diameter of each dot (in points).
  /// Affects the visual size of indicators and participates in width/height calculations.
  private var size: CGFloat = 6

  /// The horizontal and vertical padding applied inside the container.
  /// Used to compute `containerHeight` and to inset the `stackView` within the visual effect container.
  private var padding: CGFloat = 6

  /// The currently selected page index.
  /// Used to determine which indicator is highlighted and how widths/transforms are applied.
  private var currentPage: Int = 0

  /// The total number of pages/indicators displayed.
  /// Must be greater than zero; used to build and update the arranged subviews.
  private var numberOfPages: Int = 1

  /// The scale applied to non-selected indicators.
  /// A value of `1` means no scaling; values below `1` visually shrink unselected dots.
  private var minimumScaleFactor: CGFloat = 0.9


  /// In the case of a long list, we don't want out indicators to overflow the screen
  /// For better result try using only odd number
  private let maxNumberOfVisiblePages: Int = 11

  /// The total height of the indicator container.
  ///
  /// Computed as the dot `size` plus vertical padding on both sides (`padding * 2`).
  /// Useful when laying out this view externally or matching surrounding constraints.
  var containerHeight: CGFloat {
    get {
      return size + padding * 2
    }
  }

  public func setNumberOfPages(_ numberOfPages: Int) {
    assert(numberOfPages > 0, "Number of pages must be greater than zero")

    self.alpha = numberOfPages > 1 ? 1 : 0
    self.numberOfPages = numberOfPages
    stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    indicatorCollections = [:]
    (0..<numberOfPages).forEach { i in
      let circle = IndicatorView()
      circle.backgroundColor = i == currentPage ? currentPageIndicatorTintColor : pageIndicatorTintColor
      circle.tag = i

      circle.layer.cornerRadius = size / 2
      circle.height(size)
      let widthConstraint = circle.widthAnchor.constraint(equalToConstant: i == currentPage ? currentPageWidth : size)
      widthConstraint.isActive = true
      indicatorWidthConstraints[i] = widthConstraint

      stackView.addArrangedSubview(circle)
      let scale: CGFloat = i == currentPage ? 1 : minimumScaleFactor
      circle.transform = CGAffineTransform(scaleX: scale, y: scale)
      self.indicatorCollections[i] = circle
    }

    let min = min(maxNumberOfVisiblePages, numberOfPages)
    let maxWidth = CGFloat(min) * size + CGFloat(min - 1) * spacing + (2 * padding)

    widthConstraint?.constant = maxWidth

    let totalWidth = CGFloat(numberOfPages) * size + CGFloat(numberOfPages - 1) * spacing
    stackViewWidthConstraint?.constant = totalWidth
  }
  public func setCurrentPage(_ nextPage: Int, withAnimation: Bool = true) {
    if nextPage < 0 || nextPage >= numberOfPages {
      return
    }

    let currentView: IndicatorView = indicatorCollections[currentPage]!
    let nextView: IndicatorView = indicatorCollections[nextPage]!

    UIView.animate(withDuration: 0.15) { [self] in
      currentView.transform = CGAffineTransform(scaleX: self.minimumScaleFactor, y: self.minimumScaleFactor)
      currentView.backgroundColor = self.pageIndicatorTintColor
      nextView.transform = .identity
      nextView.backgroundColor = self.currentPageIndicatorTintColor
      if numberOfPages > maxNumberOfVisiblePages {
        let offset = Int(maxNumberOfVisiblePages / 2)
        if numberOfPages - nextPage > offset {
          if nextPage > offset {
            if nextPage == numberOfPages - 1 {
              return
            }
            let leftOffset = nextPage - (maxNumberOfVisiblePages - offset - 1)
            if leftOffset > 0 {
              let offsetY = abs(CGFloat(leftOffset) * (spacing + size))
              stackView.transform = CGAffineTransform.init(translationX: -offsetY, y: 0)
            } else {
              stackView.transform = .identity
            }
          } else {
            stackView.transform = .identity
          }
        }
      }
    }

    self.currentPage = nextPage
  }

  public func next() {
    if currentPage < numberOfPages - 1 {
      currentPage += 1
      setCurrentPage(currentPage)
    }
  }

  public func previous() {
    if currentPage > 0 {
      currentPage -= 1
      setCurrentPage(currentPage)
    }
  }

  var alignment: BXPageControl.Alignment = .center {
    didSet {
      switch alignment {
      case .leading:
        leadingConstraint?.isActive = true
        trailingConstraint?.isActive = false
        centerConstraint?.isActive = false
      case .trailing:
        leadingConstraint?.isActive = false
        trailingConstraint?.isActive = true
        centerConstraint?.isActive = false
      case .center:
        leadingConstraint?.isActive = false
        trailingConstraint?.isActive = false
        centerConstraint?.isActive = true
      }
    }
  }
  var style: BXPageControl.Style = .dot
  init(alignment: Alignment = .center, style: BXPageControl.Style) {
    self.alignment = alignment
    self.style = style
    super.init(frame: .zero)
    setupViews()
  }

  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Prepare Layout
  private func resetSubviews() {

    stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    subviews.forEach { subview in
      if subview.isKind(of: IndicatorView.self) {
        subview.removeFromSuperview()
      }
    }
    (0..<numberOfPages).forEach { i in
      let circle = IndicatorView()
      circle.setIndicatorColor(i == self.currentPage ? self.currentPageIndicatorTintColor : self.pageIndicatorTintColor)
      circle.tag = i

      let widthConstraint = circle.widthAnchor.constraint(equalToConstant: i == currentPage ? currentPageWidth : size)
      widthConstraint.isActive = true
      indicatorWidthConstraints[i] = widthConstraint

      stackView.addArrangedSubview(circle)
    }
  }
  private func setupViews() {

    containerVisualEffectView.layout(in: self) {
      $0.top()
        .bottom()
    }
    leadingConstraint = containerVisualEffectView.leadingAnchor.constraint(equalTo: leadingAnchor)
    trailingConstraint = containerVisualEffectView.trailingAnchor.constraint(equalTo: trailingAnchor)
    centerConstraint = containerVisualEffectView.centerXAnchor.constraint(equalTo: centerXAnchor)
    switch alignment {
    case .leading:
      leadingConstraint?.isActive = true
      trailingConstraint?.isActive = false
      centerConstraint?.isActive = false
    case .trailing:
      leadingConstraint?.isActive = false
      trailingConstraint?.isActive = true
      centerConstraint?.isActive = false
    case .center:
      leadingConstraint?.isActive = false
      trailingConstraint?.isActive = false
      centerConstraint?.isActive = true
    }

    stackView.layout(in: self.containerVisualEffectView) {
      $0.leading(padding)
        .bottom(padding)
        .top(padding)
    }
    stackViewWidthConstraint = stackView.widthAnchor.constraint(equalToConstant: 0)
    stackViewWidthConstraint?.isActive = true

    widthConstraint = containerVisualEffectView.widthAnchor.constraint(equalToConstant: 0)
    widthConstraint?.isActive = true
  }
}

extension BXPageControl {
  static var `default`: BXPageControl {
    return .init(alignment: .center, style: .dot)
  }
  static var snake: BXPageControl {
    return .init(alignment: .leading, style: .snake)
  }
}
