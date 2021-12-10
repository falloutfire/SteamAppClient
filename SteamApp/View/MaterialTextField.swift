//
//  MaterialTextField.swift
//  SteamApp
//
//  Created by Ilya Manny on 22.10.2021.
//

import UIKit

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.height
    }
}

@IBDesignable class MaterialUITextField: UITextField {
    
    //
    //# MARK: - Variables
    //
    
    // Bottom border layer
    private var borderLayer: CAShapeLayer!
    // Top label layer
    private var labelLayer: CATextLayer!
    // Note icon layer
    private var noteIconLayer: CALayer!
    // Note text layer
    private var noteTextLayer: CATextLayer!
    // Error text layer
    private var errorIconLayer: CALayer!
    // Error text layer
    private var errorTextLayer: CATextLayer!
    // Note font size
    private var noteFontSize: CGFloat = 12.0
    // Cache secure text initial state
    private var isSecureText: Bool?
    // The button to toggle secure text entry
    private var secureToggler: UIButton!
    
    private var errorText: String? = nil {
        didSet {
            errorTextLayer.string = errorText
        }
    }
    
    private enum icon: String {
        case openEye = "\u{f06e}"
        case closedEye = "\u{f070}"
    }
    
    // The color of the bottom border
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // The widht of the bottom border
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // The color of the label
    @IBInspectable var labelColor: UIColor = UIColor.clear {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // The color of note text
    @IBInspectable var noteTextColor: UIColor = UIColor.clear {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // The color of note text
    @IBInspectable var errorTextColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // The note text
    @IBInspectable var noteText: String? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // The color of note icon
    var noteIconColor: UIColor = UIColor.clear {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // The note icon
    @IBInspectable var noteIcon: UIImage? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var errorIcon: UIImage? = UIImage(systemName: "exclamationmark.circle.fill") {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var secureTextEntry: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var clearButtonEntry: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    //
    //# MARK: - Initialization
    //
    
    #if !TARGET_INTERFACE_BUILDER
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //font = UIFont(name: "Montserrat-Light", size: 14.0)
        initRightView()
        registerNotifications()
    }
    #endif
    
    //
    // Cleanup the notification/event listeners when the view is about to dissapear
    //
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        if newWindow == nil {
            //NotificationCenter.default.removeObserver(self)
            removeTarget(self, action: #selector(MaterialUITextField.startTextChanged), for: .editingDidBegin)
            removeTarget(self, action: #selector(MaterialUITextField.endTextChanged), for: .editingDidEnd)
        } else {
            registerNotifications()
        }
    }
    
    func registerNotifications() {
        addTarget(self, action: #selector(MaterialUITextField.startTextChanged), for: .editingDidBegin)
        addTarget(self, action: #selector(MaterialUITextField.endTextChanged), for: .editingDidEnd)
    }
    
    func initRightView() {
        if isSecureText != nil {
            // Show the secure text toggler
            let togglerText: String = icon.closedEye.rawValue
            let togglerFont: UIFont = font ?? UIFont.systemFont(ofSize: 12)
            let togglerTextSize = (togglerText as NSString).size(withAttributes: [NSAttributedString.Key.font: togglerFont])
            
            secureToggler = UIButton(type: .custom)
            secureToggler.frame = CGRect(x: 0, y: 0, width: togglerTextSize.width, height: togglerTextSize.height)
            secureToggler.setTitle(togglerText, for: .normal)
            secureToggler.setTitleColor(UIColor.black, for: .normal)
            secureToggler.titleLabel?.font = togglerFont
            secureToggler.addTarget(self, action: #selector(MaterialUITextField.toggleSecureTextEntry), for: .touchUpInside)
            
            rightView = secureToggler
            rightViewMode = .always
        } else {
            // Show the clear button
            if clearButtonEntry {
                self.clearButtonMode = .whileEditing
            } else {
                self.clearButtonMode = .never
            }
        }
    }
    
    //
    // Add border layer as sub layer
    //
    func setupBorder() {
        if borderLayer == nil {
            borderLayer = CAShapeLayer()
            borderLayer.frame = layer.bounds
            layer.addSublayer(borderLayer)
        }
    }
    
    func setupLabel() {
        if labelLayer == nil && placeholder != nil {
            let labelSize = ((placeholder! as NSString)).size(withAttributes: [NSAttributedString.Key.font: font!])
            let labelSizeWidth = labelSize.width
            let labelSizeHeight = labelSize.height
            
            labelLayer = CATextLayer()
            labelLayer.opacity = 1
            labelLayer.string = placeholder
            labelLayer.font = font
            labelLayer.fontSize = (font?.pointSize)!
            labelLayer.foregroundColor = labelColor.cgColor
            labelLayer.backgroundColor = UIColor.red.cgColor
            labelLayer.isWrapped = false
            labelLayer.alignmentMode = CATextLayerAlignmentMode.left
            labelLayer.contentsScale = UIScreen.main.scale
            labelLayer.frame = CGRect(x: 0, y: (layer.bounds.size.height - labelSizeHeight) / 2.0, width: labelSizeWidth, height: labelSizeHeight)
            
            layer.addSublayer(labelLayer)
        }
    }
    
    func setupNote() {
        if noteIconLayer == nil {
            noteIconLayer = CALayer()
            noteIconLayer.contentsScale = UIScreen.main.scale
            layer.addSublayer(noteIconLayer)
        }
        
        if noteTextLayer == nil {
            noteTextLayer = CATextLayer()
            noteTextLayer.font = font
            noteTextLayer.fontSize = noteFontSize
            noteTextLayer.isWrapped = true
            noteTextLayer.alignmentMode = CATextLayerAlignmentMode.left
            noteTextLayer.contentsScale = UIScreen.main.scale
            
            layer.addSublayer(noteTextLayer)
        }
    }
    
    func setupError() {
        if errorIconLayer == nil {
            errorIconLayer = CALayer()
            errorIconLayer.contentsScale = UIScreen.main.scale
            layer.addSublayer(errorIconLayer)
        }
        
        if errorTextLayer == nil {
            errorTextLayer = CATextLayer()
            errorTextLayer.font = font
            errorTextLayer.fontSize = noteFontSize
            errorTextLayer.isWrapped = true
            errorTextLayer.alignmentMode = CATextLayerAlignmentMode.left
            errorTextLayer.contentsScale = UIScreen.main.scale
            
            layer.addSublayer(errorTextLayer)
        }
    }
    
    
    
    //
    //# MARK: - Renderers
    //
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupLayer()
    }
    
    func setupLayer() {
        layer.masksToBounds = false
        
        setupBorder()
        setupLabel()
        setupNote()
        setupError()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        drawBorder()
        drawLabel()
        drawNote()
        drawError()
    }
    
    //
    // Redraw the border
    //
    func drawBorder() {
        if borderLayer != nil {
            let size = layer.frame.size
            let path = UIBezierPath()
            
            path.move(to: CGPoint(x: 0, y: size.height))
            path.addLine(to: CGPoint(x: size.width, y: size.height))
            path.close()
            
            borderLayer.lineWidth = borderWidth
            borderLayer.strokeColor = borderColor.cgColor
            borderLayer.path = path.cgPath
        }
    }
    
    //
    // Redraw the label
    //
    func drawLabel() {
        if labelLayer != nil {
            labelLayer.foregroundColor = labelColor.cgColor
        }
    }
    
    //
    // Redraw the note
    //
    func drawNote() {
        var startX:CGFloat = 0.0
        
        if noteIconLayer != nil {
            let noteIconFont: UIFont = font ?? UIFont.systemFont(ofSize: 12)
            
            let noteIconSize = (noteText! as NSString).size(withAttributes: [NSAttributedString.Key.font: noteIconFont])
            
            noteIconLayer.frame = CGRect(x: 0, y: layer.bounds.size.height + 2, width: noteIconSize.height, height: noteIconSize.height)
            
            let maskLayer = CALayer()
            maskLayer.frame = noteIconLayer.bounds
            maskLayer.contents = noteIcon?.cgImage
            noteIconLayer.mask = maskLayer
            noteIconLayer.backgroundColor = UIColor.red.cgColor
            
            if noteIcon != nil {
                startX = noteIconSize.height + 2
            }
        }
        
        if noteTextLayer != nil {
            let noteWidth = layer.bounds.size.width - startX
            let noteHeight = (noteText ?? "").heightWithConstrainedWidth(width: noteWidth, font: font ?? UIFont.systemFont(ofSize: 12))
            
            noteTextLayer.string = noteText
            noteTextLayer.foregroundColor = noteTextColor.cgColor
            noteTextLayer.frame = CGRect(x: startX, y: layer.bounds.size.height + 2, width: noteWidth, height: noteHeight)
        }
    }
    
    func drawError() {
        var startX:CGFloat = 0.0
        
        if errorIconLayer != nil {
            let noteIconFont: UIFont = font ?? UIFont.systemFont(ofSize: 12)
            
            let noteIconSize = ((errorText ?? "") as NSString).size(withAttributes: [NSAttributedString.Key.font: noteIconFont])
            
            errorIconLayer.frame = CGRect(x: 0, y: layer.bounds.size.height + 2, width: noteIconSize.height, height: noteIconSize.height)
            
            let maskLayer = CALayer()
            maskLayer.frame = errorIconLayer.bounds
            maskLayer.contents = errorIcon?.cgImage
            errorIconLayer.mask = maskLayer
            errorIconLayer.backgroundColor = errorTextColor.cgColor
            
            if errorIcon != nil {
                startX = noteIconSize.height + 2
            }
        }
        
        if errorTextLayer != nil {
            let noteWidth = layer.bounds.size.width - startX
            let noteHeight = (errorText ?? "").heightWithConstrainedWidth(width: noteWidth, font: font ?? UIFont.systemFont(ofSize: 12))
            
            errorTextLayer.string = errorText
            errorTextLayer.foregroundColor = errorTextColor.cgColor
            errorTextLayer.frame = CGRect(x: startX, y: layer.bounds.size.height + 2, width: noteWidth, height: noteHeight)
            
        }
        errorTextLayer.isHidden = true
        errorIconLayer.isHidden = true
    }
    
    //
    //# MARK: - Event handlers
    //
    
    @objc func toggleSecureTextEntry() {
        // Resign and restore the first responder
        // solves the font issue
        resignFirstResponder()
        secureTextEntry = !secureTextEntry
        becomeFirstResponder()
        
        secureToggler.setTitle(secureTextEntry ? icon.closedEye.rawValue : icon.openEye.rawValue, for: .normal)
        
        // A trick to reset the cursor position after toggle secureTextEntry
        let temp = text
        text = nil
        text = temp
    }
    
    //
    // Apply animations when editing text
    //
    
    @objc func endTextChanged() {
        if placeholder == nil || labelLayer == nil {
            return
        }
        let labelSize = ((placeholder! as NSString)).size(withAttributes: [NSAttributedString.Key.font: font!])
        if text?.count == 0 {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { [weak self] in
                guard let self = self else { return }
                self.labelLayer.frame.origin.y = (self.layer.bounds.size.height - labelSize.height) / 2
                self.labelLayer.fontSize = 14.0
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { [weak self] in
                guard let self = self else { return }
                self.labelLayer.frame.origin.y = -labelSize.height
                self.labelLayer.fontSize = 14.0 * 0.8
            }, completion: nil)
        }
    }
    
    @objc func startTextChanged() {
        if placeholder == nil || labelLayer == nil {
            return
        }
        
        let labelSize = ((placeholder! as NSString)).size(withAttributes: [NSAttributedString.Key.font: font!])
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            guard let self = self else { return }
            self.labelLayer.frame.origin.y = -labelSize.height
            self.labelLayer.fontSize = 14.0 * 0.8
        }, completion: nil)
    }
    
    func setError(text: String?) {
        if let value = text {
            errorText = value
            noteIconLayer.isHidden = true
            noteTextLayer.isHidden = true
            errorIconLayer.isHidden = false
            errorTextLayer.isHidden = false
        } else {
            errorText = nil
            errorIconLayer.isHidden = true
            errorTextLayer.isHidden = true
            if noteText != nil {
                noteIconLayer.isHidden = false
                noteTextLayer.isHidden = false
            }
        }
    }
}
