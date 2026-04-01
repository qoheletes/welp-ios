import SwiftUI
#if canImport(UIKit)
import UIKit
#endif
import ThirdPartyLibrary

// MARK: - ResponseView

public struct ResponseView: View {

  // MARK: Lifecycle

  public init() { }

  // MARK: Public

  public var body: some View {
    ZStack(alignment: .top) {
      Color.welpBg.ignoresSafeArea()

      // Confetti layer — rendered above everything, pointer events pass through.
      #if canImport(UIKit)
      if showConfetti {
        ConfettiView()
          .ignoresSafeArea()
          .allowsHitTesting(false)
          .zIndex(10)
      }
      #endif

      VStack(spacing: 0) {
        Spacer()

        responseContent

        Spacer()

        tryAgainButton
          .padding(.horizontal, 24)
          .padding(.bottom, 48)
          .opacity(buttonOpacity)
      }
    }
    .preferredColorScheme(.dark)
    .onAppear { viewModel.fetchResponse() }
    .onChange(of: viewModel.fetchState) { _, newState in
      handleStateChange(newState)
    }
  }

  // MARK: Private

  @State private var viewModel = ResponseViewModel()

  @State private var textScale: CGFloat = 0.6
  @State private var textOpacity: Double = 0
  @State private var showConfetti = false
  @State private var buttonOpacity: Double = 0

  @ViewBuilder
  private var responseContent: some View {
    switch viewModel.fetchState {
    case .idle:
      EmptyView()

    case .loading:
      ThinkingDotsView(visible: true)

    case .success(let text):
      Text(text)
        .font(.sbAggroBold(96))
        .foregroundStyle(Color.welpYes)
        .kerning(-4)
        .lineLimit(1)
        .minimumScaleFactor(0.4)
        .multilineTextAlignment(.center)
        .padding(.horizontal, 24)
        .scaleEffect(textScale)
        .opacity(textOpacity)
        .animation(
          .spring(response: 0.5, dampingFraction: 0.6),
          value: viewModel.responseText,
        )

    case .failure(let message):
      VStack(spacing: 12) {
        Image(systemName: "exclamationmark.triangle")
          .font(.system(size: 40))
          .foregroundStyle(Color.welpNo)

        Text(message)
          .font(.sbAggroLight(16))
          .foregroundStyle(Color.welpTextSpoken)
          .multilineTextAlignment(.center)
          .padding(.horizontal, 32)
      }
    }
  }

  private var tryAgainButton: some View {
    Button {
      handleTryAgain()
    } label: {
      Text("Try Again")
        .font(.sbAggroBold(15))
        .foregroundStyle(Color.welpTextAccent)
        .kerning(0.2)
        .frame(maxWidth: .infinity)
        .frame(height: 52)
        .background(.clear)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
          RoundedRectangle(cornerRadius: 16)
            .strokeBorder(Color.welpTextAccent, lineWidth: 2)
        )
    }
    .buttonStyle(.plain)
    .accessibilityLabel("Try Again")
    .accessibilityIdentifier("responseView.tryAgainButton")
  }

  private func handleStateChange(_ state: ResponseViewModel.FetchState) {
    switch state {
    case .success:
      revealResponse()

    case .failure:
      // Reset animation state and show button so user can retry.
      textScale = 0.6
      textOpacity = 0
      showConfetti = false
      withAnimation(.easeOut(duration: 0.2)) {
        buttonOpacity = 1
      }

    case .idle, .loading:
      // Reset animation state; hide button while loading or idle.
      textScale = 0.6
      textOpacity = 0
      showConfetti = false
      withAnimation(.easeOut(duration: 0.2)) {
        buttonOpacity = 0
      }
    }
  }

  private func revealResponse() {
    // 1. Spring scale + fade in
    withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
      textScale = 1.0
      textOpacity = 1.0
    }

    // 2. Haptic feedback
    #if canImport(UIKit)
    UINotificationFeedbackGenerator().notificationOccurred(.success)
    #endif

    // 3. Confetti burst from top
    showConfetti = true

    // 4. Fade in the Try Again button after a short delay
    withAnimation(.easeOut(duration: 0.35).delay(0.5)) {
      buttonOpacity = 1
    }
  }

  private func handleTryAgain() {
    // Reset visual state before re-fetching
    withAnimation(.easeIn(duration: 0.2)) {
      textOpacity = 0
      buttonOpacity = 0
    }
    showConfetti = false

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
      textScale = 0.6
      viewModel.reset()
      viewModel.fetchResponse()
    }
  }
}

// MARK: - ConfettiView

#if canImport(UIKit)
/// A UIViewRepresentable that wraps a `CAEmitterLayer` confetti burst.
/// The emitter fires a one-shot burst from the top of the screen and then stops.
private struct ConfettiView: UIViewRepresentable {

  func makeUIView(context _: Context) -> ConfettiUIView {
    ConfettiUIView()
  }

  func updateUIView(_: ConfettiUIView, context _: Context) { }
}

private final class ConfettiUIView: UIView {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .clear
    isUserInteractionEnabled = false
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) is not supported")
  }

  // MARK: Internal

  override func layoutSubviews() {
    super.layoutSubviews()
    guard emitter.superlayer == nil else { return }
    configureEmitter()
  }

  // MARK: Private

  private static let confettiColors: [CGColor] = [
    UIColor(Color.welpTextAccent).cgColor, // purple
    UIColor(Color.welpYes).cgColor, // green
    UIColor(Color.welpNo).cgColor, // red
    UIColor.white.cgColor,
    UIColor(Color.welpTextLight).cgColor, // light purple
  ]

  private let emitter = CAEmitterLayer()

  private func configureEmitter() {
    let width = bounds.width

    emitter.emitterPosition = CGPoint(x: width / 2, y: -10)
    emitter.emitterShape = .line
    emitter.emitterSize = CGSize(width: width, height: 1)
    emitter.renderMode = .unordered

    emitter.emitterCells = Self.confettiColors.map { makeCell(color: $0) }
    layer.addSublayer(emitter)

    // Fire a brief burst then stop the emitter.
    emitter.birthRate = 1
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
      self?.emitter.birthRate = 0
    }
  }

  private func makeCell(color: CGColor) -> CAEmitterCell {
    let cell = CAEmitterCell()

    // Shape: small rounded rectangle rendered as a CGImage
    cell.contents = confettiImage(color: color)
    cell.birthRate = 60
    cell.lifetime = 4.0
    cell.lifetimeRange = 1.5

    // Launch upward then fall under gravity
    cell.velocity = 420
    cell.velocityRange = 180
    cell.emissionLongitude = .pi / 2 // straight up
    cell.emissionRange = .pi / 3 // ±60° spread

    cell.spin = 4
    cell.spinRange = 6

    cell.scale = 0.06
    cell.scaleRange = 0.03

    // Gravity pulls pieces down
    cell.yAcceleration = 600

    cell.alphaSpeed = -0.25
    cell.color = color

    return cell
  }

  /// Renders a small rounded-rectangle swatch as a `CGImage` for the emitter cell.
  private func confettiImage(color: CGColor) -> CGImage? {
    let size = CGSize(width: 12, height: 6)
    let renderer = UIGraphicsImageRenderer(size: size)
    let uiImage = renderer.image { _ in
      let rect = CGRect(origin: .zero, size: size)
      UIColor(cgColor: color).setFill()
      UIBezierPath(roundedRect: rect, cornerRadius: 2).fill()
    }
    return uiImage.cgImage
  }
}
#endif
