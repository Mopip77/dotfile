#!/usr/bin/env swift

// -----------------------
// 
// 使用 swiftc toast.swift -o toast 编译成二进制文件
//
// -----------------------

import Cocoa

// MARK: - Helper Types

enum Position: String {
    case C, T, B, L, R
    case TL, TR, BL, BR
}

// 简单的参数解析器
class ArgumentParser {
    var message: String = "默认提醒"
    var position: Position = .C
    var fontSize: CGFloat = 24.0
    var textColor: NSColor = .white
    var duration: Double = 2.0
    var backgroundColor: NSColor = NSColor.black.withAlphaComponent(0.7)

    func parse() {
        let args = CommandLine.arguments
        // 如果没有参数，直接返回
        if args.count < 2 { return }

        var i = 1
        while i < args.count {
            let arg = args[i]
            switch arg {
            case "--text", "-t":
                if i + 1 < args.count { message = args[i+1]; i += 1 }
            case "--pos", "--position", "-p":
                if i + 1 < args.count, let pos = Position(rawValue: args[i+1]) {
                    position = pos; i += 1
                }
            case "--size", "-s":
                if i + 1 < args.count, let size = Double(args[i+1]) {
                    fontSize = CGFloat(size); i += 1
                }
            case "--color", "-c":
                if i + 1 < args.count {
                    textColor = parseColor(args[i+1]); i += 1
                }
            case "--time", "-d":
                if i + 1 < args.count, let time = Double(args[i+1]) {
                    duration = time; i += 1
                }
            default:
                // 如果参数不是 flag，且是最后一个，或者前面不是 flag，则默认为消息内容
                if !arg.starts(with: "-") {
                    message = arg
                }
            }
            i += 1
        }
    }

    func parseColor(_ input: String) -> NSColor {
        switch input.lowercased() {
        case "red": return .systemRed
        case "green": return .systemGreen
        case "blue": return .systemBlue
        case "yellow": return .systemYellow
        case "black": return .black
        case "gray": return .gray
        default:
            return colorFromHex(input) ?? .white
        }
    }

    func colorFromHex(_ hex: String) -> NSColor? {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) { cString.remove(at: cString.startIndex) }
        if ((cString.count) != 6) { return nil }
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        return NSColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
}

// MARK: - Main Logic

let config = ArgumentParser()
config.parse()

// 创建 Application 实例
let app = NSApplication.shared
app.setActivationPolicy(.accessory) // 不在 Dock 显示图标

// 计算文本尺寸以自适应窗口大小
let font = NSFont.systemFont(ofSize: config.fontSize, weight: .medium)
let attributes: [NSAttributedString.Key: Any] = [.font: font]
let textSize = (config.message as NSString).size(withAttributes: attributes)

// 窗口内边距
let padding: CGFloat = 20.0
let windowWidth = textSize.width + (padding * 2)
let windowHeight = textSize.height + (padding * 2)

// 创建窗口
let panel = NSPanel(
    contentRect: NSRect(x: 0, y: 0, width: windowWidth, height: windowHeight),
    styleMask: [.borderless, .nonactivatingPanel], // 无边框，不抢焦点
    backing: .buffered,
    defer: false
)

panel.backgroundColor = config.backgroundColor
panel.level = .floating // 悬浮在最上层
panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary] // 全屏应用上也能显示
panel.isOpaque = false
panel.hasShadow = true
panel.contentView?.wantsLayer = true
panel.contentView?.layer?.cornerRadius = 10 // 圆角

// 设置文本 View
let textField = NSTextField(labelWithString: config.message)
textField.font = font
textField.textColor = config.textColor
textField.alignment = .C
textField.frame = NSRect(x: 0, y: (windowHeight - textSize.height) / 2, width: windowWidth, height: textSize.height)
panel.contentView?.addSubview(textField)

// --- 位置计算逻辑 (macOS 坐标系原点在左下角) ---
if let screen = NSScreen.main {
    let screenRect = screen.visibleFrame
    let margin: CGFloat = 30.0 // 屏幕边缘距离
    
    var x: CGFloat = 0
    var y: CGFloat = 0
    
    // X 轴计算
    switch config.position {
    case .L, .TL, .BL:
        x = screenRect.minX + margin
    case .R, .TR, .BR:
        x = screenRect.maxX - windowWidth - margin
    case .C, .T, .B:
        x = screenRect.midX - (windowWidth / 2)
    }
    
    // Y 轴计算
    switch config.position {
    case .B, .BL, .BR:
        y = screenRect.minY + margin + 100 // 底部稍微抬高一点，避免遮挡 Dock
    case .T, .TL, .TR:
        y = screenRect.maxY - windowHeight - margin
    case .C, .L, .R:
        y = screenRect.midY - (windowHeight / 2)
    }
    
    panel.setFrameOrigin(NSPoint(x: x, y: y))
}

// 显示窗口
panel.makeKeyAndOrderFront(nil)

// 定时退出
DispatchQueue.main.asyncAfter(deadline: .now() + config.duration) {
    NSApp.terminate(nil)
}

app.run()