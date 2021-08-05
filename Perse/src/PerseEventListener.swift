/**
 * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 * Perse SDK iOS
 * More About: https://www.getperse.com/
 * From CyberLabs.AI: https://cyberlabs.ai/
 * Haroldo Teruya @ Cyberlabs AI 2021
 * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 */

import Foundation
import PerseLite

/**
 PerseCamera interface callbacks.
 */
public protocol PerseEventListener {

    func onImageCaptured(
        _ count: Int,
        _ total: Int,
        _ imagePath: String,
        _ detectResponse: DetectResponse?
    )

    func onFaceDetected(
        _ x: Int,
        _ y: Int,
        _ width: Int,
        _ height: Int,
        _ leftEyeOpen: Bool,
        _ rightEyeOpen: Bool,
        _ smiling: Bool,
        _ headVerticalMovement: HeadMovement,
        _ headHorizontalMovement: HeadMovement,
        _ headTiltMovement: HeadMovement
    )

    func onFaceUndetected()

    func onEndCapture()

    func onError(_ error: String)

    func onMessage(_ message: String)

    func onPermissionDenied()
    
    func onQRCodeScanned(_ content: String) 
}
