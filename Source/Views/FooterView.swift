import UIKit

public protocol FooterViewDelegate: class {

  func footerView(_ footerView: FooterView, didExpand expanded: Bool)
}

open class FooterView: UIView {

  open fileprivate(set) lazy var infoLabel: InfoLabel = { [unowned self] in
    let label = InfoLabel(text: "")
    label.isHidden = !LightboxConfig.InfoLabel.enabled
    label.textAlignment = .center
    label.textColor = LightboxConfig.InfoLabel.textColor
    label.isUserInteractionEnabled = true
    label.delegate = self

    return label
  }()

  let gradientColors = [UIColor(hex: "040404").withAlphaComponent(0.8), UIColor(hex: "040404")]
  open weak var delegate: FooterViewDelegate?

  // MARK: - Initializers

  public init() {
    super.init(frame: CGRect.zero)

    backgroundColor = UIColor.clear
    _ = addGradientLayer(gradientColors)

    [infoLabel].forEach { addSubview($0) }
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Helpers

  func expand(_ expand: Bool) {
    expand ? infoLabel.expand() : infoLabel.collapse()
  }

  func updateText(_ text: String) {
    infoLabel.fullText = text

    if text.isEmpty {
      _ = removeGradientLayer()
    } else if !infoLabel.expanded {
      _ = addGradientLayer(gradientColors)
    }
  }

  open override func layoutSubviews() {
    super.layoutSubviews()


    infoLabel.frame.origin.y = 5

    resizeGradientLayer()
  }
}

// MARK: - LayoutConfigurable

extension FooterView: LayoutConfigurable {

  @objc public func configureLayout() {
    infoLabel.frame = CGRect(x: 17, y: 0, width: frame.width - 17 * 2, height: 35)
    infoLabel.configureLayout()
  }
}

extension FooterView: InfoLabelDelegate {

  public func infoLabel(_ infoLabel: InfoLabel, didExpand expanded: Bool) {
    _ = (expanded || infoLabel.fullText.isEmpty) ? removeGradientLayer() : addGradientLayer(gradientColors)
    delegate?.footerView(self, didExpand: expanded)
  }
}
