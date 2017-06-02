//
//  ColorPicker.swift
//  ColorPicker
//
//  Created by moomoon on 01/06/2017.
//  Copyright © 2017 dr. All rights reserved.
//

import Foundation
import UIKit

extension Sequence where Iterator.Element == View {
  var cells: AnySequence<(Cell, UIColor)> {
    return .init(lazy.flatMap {
      switch $0 {
      case let .cell(content): return content
      case _: return nil
      }
    })
  }
}
fileprivate enum View { case view(UIView), cell(Cell, UIColor) }
fileprivate enum Cell { case end(background: UIView, popup: UIView, [NSLayoutConstraint]), cell(UIView, [NSLayoutConstraint]) }
extension Cell: Equatable {
  func popup(_ visible: Bool) {
    switch self {
    case let .end(_, popup, constraints):
      if visible {
        popup.superview?.bringSubview(toFront: popup)
        popup.alpha = 1
        popup.layer.borderWidth = 1
        popup.layer.cornerRadius = 2
        NSLayoutConstraint.activate(constraints)
      } else {
        popup.alpha = 0
        popup.layer.borderWidth = 0
        popup.layer.cornerRadius = 0
        NSLayoutConstraint.deactivate(constraints)
      }
    case let .cell(view, constraints):
      if visible {
        view.superview?.bringSubview(toFront: view)
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 2
        NSLayoutConstraint.activate(constraints)
      } else {
        view.layer.borderWidth = 0
        view.layer.cornerRadius = 0
        NSLayoutConstraint.deactivate(constraints)
      }
    }
    
  }
  static func == (lhs: Cell, rhs: Cell) -> Bool {
    switch (lhs, rhs) {
    case let (.end(lbg, lpopup, _), .end(rbg, rpopup, _)): return lbg == rbg && lpopup == rpopup
    case let (.cell(l, _), .cell(r, _)): return l == r
    case _: return false
    }
  }
}
extension View {
  func removeFromSuperview() {
    switch self {
    case let .view(view): view.removeFromSuperview()
    case let .cell(.end(background, popup, _), _): background.removeFromSuperview(); popup.removeFromSuperview()
    case let .cell(.cell(view, _), _): view.removeFromSuperview()
    }
  }
}
fileprivate extension NSLayoutConstraint {
  convenience init(_ item: Any, _ attribute: NSLayoutAttribute, _ relation: NSLayoutRelation = .equal, to toItem: Any? = nil, _ toAttribute: NSLayoutAttribute = .notAnAttribute, multiplier: CGFloat = 1, constant: CGFloat = 0, priority: UILayoutPriority = 1000) {
    self.init(item: item, attribute: attribute, relatedBy: relation, toItem: toItem, attribute: toAttribute, multiplier: multiplier, constant: constant)
    self.priority = priority
  }
}
fileprivate extension UIView {
  func point(inside point: CGPoint, from view: UIView, with event: UIEvent?) -> Bool {
    return self.point(inside: convert(point, from: view), with: event)
  }
  convenience init(backgroundColor: UIColor) {
    self.init()
    self.backgroundColor = backgroundColor
    translatesAutoresizingMaskIntoConstraints = false
    
  }
}
fileprivate struct Border {
  let color: UIColor
  let width: CGFloat
  let cornerRadius: CGFloat
}
fileprivate class ViewHolder {
  private let views: [View]
  var selected: (Cell, UIColor)? {
    willSet(newValue) {
      UIView.animate(withDuration: 0.3) {
        self.selected?.0.popup(false)
        newValue?.0.popup(true)
        self.parent.layoutIfNeeded()
      }
    }
    didSet {
      parent.sendActions(for: .valueChanged)
    }
  }
  private weak var parent: ColorPicker!
  init(colors: [UIColor], picker: ColorPicker, border: Border) {
    self.parent = picker
    let background = UIView()
    background.translatesAutoresizingMaskIntoConstraints = false
    background.isUserInteractionEnabled = false
    background.layer.masksToBounds = true
    picker.addSubview(background)
    let scale: CGFloat = 1.5
    (background.layer.borderColor, background.layer.borderWidth, background.layer.cornerRadius) = (border.color.cgColor, border.width, border.cornerRadius)
    NSLayoutConstraint.activate([
      .init(background, .width, to: picker, .width),
      .init(background, .height, to: picker, .height),
      .init(background, .centerX, to: picker, .centerX),
      .init(background, .centerY, to: picker, .centerY),
      ])
    self.views = [.view(background)] + colors.enumerated().map { offset, color in
      switch offset {
      case 0:
        let (bg, popup) = (UIView(backgroundColor: color), UIView(backgroundColor: color))
        popup.alpha = 0
        popup.layer.borderColor = border.color.cgColor
        background.addSubview(bg)
        picker.addSubview(popup)
        NSLayoutConstraint.activate([
          .init(bg, .leading, to: background, .leading),
          .init(bg, .centerY, to: background, .centerY),
          .init(bg, .height, to: background, .height),
          .init(bg, .width, to: background, .width, multiplier: 1 / CGFloat(colors.count), constant: colors.count <= 2 ? 0 : CGFloat(colors.count - 2) / CGFloat(colors.count) * border.width),
          .init(popup, .centerX, to: bg, .centerX, constant: border.width / 2),
          .init(popup, .centerY, to: bg, .centerY),
          .init(popup, .height, to: background, .height, constant: -border.width * 2, priority: 999),
          .init(popup, .width, to: bg, .width, constant: -border.width, priority: 999),
          ])
        return .cell(.end(background: bg, popup: popup, [
          .init(popup, .width, to: background, .width, multiplier: scale / CGFloat(colors.count), constant: -2 * scale / CGFloat(colors.count) * border.width),
          .init(popup, .height, to: background, .height, multiplier: scale, constant: -border.width * 2 * scale),
          ]), color)
      case colors.count - 1:
        let (bg, popup) = (UIView(backgroundColor: color), UIView(backgroundColor: color))
        popup.alpha = 0
        popup.layer.borderColor = border.color.cgColor
        background.addSubview(bg)
        picker.addSubview(popup)
        NSLayoutConstraint.activate([
          .init(bg, .trailing, to: background, .trailing),
          .init(bg, .centerY, to: background, .centerY),
          .init(bg, .height, to: background, .height),
          .init(bg, .width, to: background, .width, multiplier: 1 / CGFloat(colors.count), constant: colors.count <= 2 ? 0 : CGFloat(colors.count - 2) / CGFloat(colors.count) * border.width),
          .init(popup, .centerX, to: bg, .centerX, constant: -border.width / 2),
          .init(popup, .centerY, to: bg, .centerY),
          .init(popup, .height, to: background, .height, constant: -border.width * 2, priority: 999),
          .init(popup, .width, to: bg, .width, constant: -border.width, priority: 999),
          ])
        return .cell(.end(background: bg, popup: popup, [
          .init(popup, .width, to: background, .width, multiplier: scale / CGFloat(colors.count), constant: -2 * scale / CGFloat(colors.count) * border.width),
          .init(popup, .height, to: background, .height, multiplier: scale, constant: -border.width * 2 * scale),
          ]), color)
      case _:
        let view = UIView(backgroundColor: color)
        view.layer.borderColor = border.color.cgColor
        picker.addSubview(view)
        NSLayoutConstraint.activate([
          .init(view, .centerX, to: background, .trailing, multiplier: CGFloat(2 * offset + 1) / CGFloat(2 * colors.count), constant: CGFloat(colors.count - 2 * offset - 1) / CGFloat(colors.count) * border.width),
          .init(view, .centerY, to: background, .centerY),
          .init(view, .width, to: background, .width, multiplier: 1 / CGFloat(colors.count), constant: -2 / CGFloat(colors.count) * border.width, priority: 999),
          .init(view, .height, to: background, .height, constant: -2 * border.width, priority: 999),
          ])
        return .cell(.cell(view, [
        .init(view, .width, to: background, .width, multiplier: scale / CGFloat(colors.count), constant: -2 * scale / CGFloat(colors.count) * border.width),
        .init(view, .height, to: background, .height, multiplier: scale, constant: -2 * scale * border.width),
          ]), color)
      }
    }
  }
  func select(_ color: UIColor?) {
    selected = color.flatMap { color in
      self.views.cells.first { $1 == color }
    }
  }
  func track(touch: UITouch, with event: UIEvent?) -> Bool {
    guard let hit = views.cells.first(where: { cell, _ in
      switch cell {
      case let .end(view, _, _): return view.point(inside: touch.location(in: view), with: event)
      case let .cell(view, _): return view.point(inside: touch.location(in: view), with: event)
      }
    }), hit.1 != selected?.1 else { return false }
    selected = hit
    return true
  }
  deinit {
    views.forEach { $0.removeFromSuperview() }
  }
}
class ColorPicker: UIControl {
  @IBInspectable var borderWidth: CGFloat = 1
  @IBInspectable var borderColor: UIColor = .white
  @IBInspectable var cornerRadius: CGFloat = 2
  private var holder: ViewHolder?
  var colors: [UIColor] = [] {
    didSet {
      holder = .init(colors: colors, picker: self, border: .init(color: borderColor, width: borderWidth, cornerRadius: cornerRadius))
      selectedColor = nil
    }
  }
  var selectedView: UIView? {
    switch holder?.selected?.0 {
    case nil: return nil
    case let .end(_, view, _)?: return view
    case let .cell(view, _)?: return view
    }
  }
  var selectedColor: UIColor? {
    get { return holder?.selected?.1 }
    set { if newValue != selectedColor { holder?.select(newValue) } }
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    isUserInteractionEnabled = true
  }
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    _ = holder?.track(touch: touch, with: event)
  }
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    _ = holder?.track(touch: touch, with: event)
  }
}
