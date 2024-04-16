import SwiftUI
import Combine

/// 跑马灯效果控件 https://github.com/joekndy/MarqueeText

public struct PPMarqueeText : View {
    public var text: String
    public var font: UIFont
    public var leftFade: CGFloat
    public var rightFade: CGFloat
    public var startDelay: Double
    public var alignment: Alignment
    
    @State private var animate = false
    var isCompact = false
    
    public var body : some View {
        let stringWidth = text.widthOfString(usingFont: font)
        let stringHeight = text.heightOfString(usingFont: font)
        
        let animation = Animation
            .linear(duration: Double(stringWidth) / 30)
            .delay(startDelay)
            .repeatForever(autoreverses: false)
        
        let nullAnimation = Animation
            .linear(duration: 0)
        
        return ZStack {
            GeometryReader { geo in
                Group {
                    if stringWidth > geo.size.width { // don't use self.animate as conditional here
                        Group {
                            Text(self.text)
                                .lineLimit(1)
                                .font(.init(font))
                                .offset(x: self.animate ? -stringWidth - stringHeight * 2 : 0)
                                .animation(self.animate ? animation : nullAnimation, value: self.animate)
                                .onAppear {
                                    Task { @MainActor in
                                        self.animate = geo.size.width < stringWidth
                                    }
                                }
                                .fixedSize(horizontal: true, vertical: false)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                            
                            Text(self.text)
                                .lineLimit(1)
                                .font(.init(font))
                                .offset(x: self.animate ? 0 : stringWidth + stringHeight * 2)
                                .animation(self.animate ? animation : nullAnimation, value: self.animate)
                                .onAppear {
                                    Task { @MainActor in
                                        self.animate = geo.size.width < stringWidth
                                    }
                                }
                                .fixedSize(horizontal: true, vertical: false)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                        }
                        .mask(
                            HStack(spacing:0) {
                                Rectangle()
                                    .frame(width:2)
                                    .opacity(0)
                                LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0), Color.black]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                                    .frame(width:leftFade)
                                LinearGradient(gradient: Gradient(colors: [Color.black, Color.black]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                                LinearGradient(gradient: Gradient(colors: [Color.black, Color.black.opacity(0)]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                                    .frame(width:rightFade)
                                Rectangle()
                                    .frame(width:2)
                                    .opacity(0)
                            })
                        .frame(width: geo.size.width)
                    } else {
                        Text(self.text)
                            .font(.init(font))
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: alignment)
                    }
                }
                .onValueChanged(of: self.text) {text in
                    self.animate = geo.size.width < stringWidth
                }
            }
        }
        .frame(height: stringHeight)
        .frame(maxWidth: isCompact ? stringWidth : nil)
        .onDisappear { self.animate = false }

    }
    
    public init(text: String, font: UIFont, leftFade: CGFloat = 0, rightFade: CGFloat = 0, startDelay: Double = 0, alignment: Alignment? = nil) {
        self.text = text
        self.font = font
        self.leftFade = leftFade
        self.rightFade = rightFade
        self.startDelay = startDelay
        self.alignment = alignment != nil ? alignment! : .topLeading
    }
}

extension PPMarqueeText {
    public func makeCompact(_ compact: Bool = true) -> Self {
        var view = self
        view.isCompact = compact
        return view
    }
}

extension View {
    /// A backwards compatible wrapper for iOS 14 `onChange`
    @ViewBuilder func onValueChanged<T: Equatable>(of value: T, perform onChange: @escaping (T) -> Void) -> some View {
        if #available(iOS 14.0, *) {
            self.onChange(of: value, perform: onChange)
        } else {
            self.onReceive(Just(value)) { (value) in
                onChange(value)
            }
        }
    }
}


extension String {
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }

    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
}
