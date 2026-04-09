//  XSProgressHUD.swift
//  XSNetwork
import Foundation
#if canImport(UIKit)
import UIKit

@objcMembers
@objc public class XSProgressHUD: NSObject {
    private var containerView: UIView?

    @objc public static func showLoading(in view: UIView, message: String?) -> XSProgressHUD {
        let hud = XSProgressHUD()
        DispatchQueue.main.async { hud._showLoading(in: view, message: message) }
        return hud
    }

    @objc public func hide(animated: Bool) {
        DispatchQueue.main.async { self._hide(animated: animated) }
    }

    @objc public static func showToast(_ message: String, in view: UIView, afterDelay delay: TimeInterval) {
        guard !message.isEmpty else { return }
        DispatchQueue.main.async { _showToast(message, in: view, afterDelay: delay) }
    }

    private func _showLoading(in view: UIView, message: String?) {
        let overlay = UIView(frame: view.bounds)
        overlay.isUserInteractionEnabled = false
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView = overlay
        let bezel = UIView()
        bezel.backgroundColor = UIColor(white: 0, alpha: 0.7)
        bezel.layer.cornerRadius = 10
        bezel.clipsToBounds = true
        let ind: UIActivityIndicatorView
        if #available(iOS 13, *) { ind = UIActivityIndicatorView(style: .medium); ind.color = .white }
        else { ind = UIActivityIndicatorView(style: .white) }
        ind.startAnimating()
        let sz: CGFloat = 60
        bezel.frame = CGRect(x: (view.bounds.width-sz)/2, y: (view.bounds.height-sz)/2, width: sz, height: sz)
        ind.frame = CGRect(x: (sz-37)/2, y: (sz-37)/2, width: 37, height: 37)
        bezel.addSubview(ind)
        overlay.addSubview(bezel)
        overlay.alpha = 0
        view.addSubview(overlay)
        UIView.animate(withDuration: 0.25) { overlay.alpha = 1 }
    }

    private func _hide(animated: Bool) {
        guard let v = containerView else { return }
        containerView = nil
        if animated { UIView.animate(withDuration: 0.25, animations: { v.alpha = 0 }) { _ in v.removeFromSuperview() } }
        else { v.removeFromSuperview() }
    }

    private static func _showToast(_ message: String, in view: UIView, afterDelay delay: TimeInterval) {
        let toast = UIView()
        toast.backgroundColor = UIColor(white: 0, alpha: 0.7)
        toast.layer.cornerRadius = 10
        toast.isUserInteractionEnabled = false
        let lbl = UILabel()
        lbl.text = message; lbl.textColor = .white; lbl.font = .systemFont(ofSize: 14)
        lbl.textAlignment = .center; lbl.numberOfLines = 0
        let maxW = min(view.bounds.width - 40, 200)
        let ts = message.boundingRect(with: CGSize(width: maxW-32, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin, attributes: [.font: lbl.font!], context: nil).size
        let tw = ceil(ts.width)+32, th = ceil(ts.height)+24
        toast.frame = CGRect(x: (view.bounds.width-tw)/2, y: view.bounds.height-th-60, width: tw, height: th)
        lbl.frame = CGRect(x: 16, y: 12, width: tw-32, height: th-24)
        toast.addSubview(lbl); toast.alpha = 0; view.addSubview(toast)
        UIView.animate(withDuration: 0.25, animations: { toast.alpha = 1 }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now()+delay) {
                UIView.animate(withDuration: 0.25, animations: { toast.alpha = 0 }) { _ in toast.removeFromSuperview() }
            }
        }
    }
}
#else
import AppKit

@objcMembers
@objc public class XSProgressHUD: NSObject {
    private var containerView: NSView?

    @objc public static func showLoading(in view: NSView, message: String?) -> XSProgressHUD {
        let hud = XSProgressHUD()
        DispatchQueue.main.async { hud._showLoading(in: view, message: message) }
        return hud
    }

    @objc public func hide(animated: Bool) {
        DispatchQueue.main.async { self._hide(animated: animated) }
    }

    @objc public static func showToast(_ message: String, in view: NSView, afterDelay delay: TimeInterval) {
        guard !message.isEmpty else { return }
        DispatchQueue.main.async { _showToast(message, in: view, afterDelay: delay) }
    }

    private func _showLoading(in view: NSView, message: String?) {
        let overlay = NSView(frame: view.bounds)
        overlay.wantsLayer = true
        overlay.autoresizingMask = [.width, .height]
        containerView = overlay
        let ind = NSProgressIndicator()
        ind.style = .spinning; ind.startAnimation(nil)
        let sz: CGFloat = 60
        ind.frame = NSRect(x: (view.bounds.width-sz)/2, y: (view.bounds.height-sz)/2, width: sz, height: sz)
        overlay.addSubview(ind); overlay.alphaValue = 0; view.addSubview(overlay)
        NSAnimationContext.runAnimationGroup { c in c.duration = 0.25; overlay.animator().alphaValue = 1 }
    }

    private func _hide(animated: Bool) {
        guard let v = containerView else { return }
        containerView = nil
        if animated { NSAnimationContext.runAnimationGroup({ c in c.duration = 0.25; v.animator().alphaValue = 0 }) { v.removeFromSuperview() } }
        else { v.removeFromSuperview() }
    }

    private static func _showToast(_ message: String, in view: NSView, afterDelay delay: TimeInterval) {
        let toast = NSView()
        toast.wantsLayer = true
        toast.layer?.backgroundColor = NSColor(white: 0, alpha: 0.7).cgColor
        toast.layer?.cornerRadius = 10
        let lbl = NSTextField(labelWithString: message)
        lbl.textColor = .white; lbl.font = .systemFont(ofSize: 14); lbl.alignment = .center
        let tw: CGFloat = 160, th: CGFloat = 40
        toast.frame = NSRect(x: (view.bounds.width-tw)/2, y: 60, width: tw, height: th)
        lbl.frame = NSRect(x: 8, y: 8, width: tw-16, height: th-16)
        toast.addSubview(lbl); toast.alphaValue = 0; view.addSubview(toast)
        NSAnimationContext.runAnimationGroup({ c in c.duration = 0.25; toast.animator().alphaValue = 1 }) {
            DispatchQueue.main.asyncAfter(deadline: .now()+delay) {
                NSAnimationContext.runAnimationGroup({ c in c.duration = 0.25; toast.animator().alphaValue = 0 }) { toast.removeFromSuperview() }
            }
        }
    }
}
#endif
