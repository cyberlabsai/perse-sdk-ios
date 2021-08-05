/**
 * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 * Perse SDK iOS
 * More About: https://www.getperse.com/
 * From CyberLabs.AI: https://cyberlabs.ai/
 * Haroldo Teruya @ Cyberlabs AI 2021
 * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 */

import UIKit
import YoonitCamera
import PerseLite

/**
 CameraView component integrated with YoonitCamera and PerseLite.
 */
@objc
open class PerseCamera: CameraView, CameraEventListenerDelegate {
        
    public var apiKey: String? {
        didSet {
            if let apiKey = apiKey {
                self.perseLite = PerseLite(apiKey: apiKey)
            }
        }
    }
        
    public var perseEventListener: PerseEventListener?
    static var url: String = "https://api.stg.getperse.com/v0/"
    public var perseLite: PerseLite?

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    private func configure() {
        self.cameraEventListener = self
        self.setTimeBetweenImages(1000)
        self.startCaptureType("face")
        self.setSaveImageCaptured(true)
    }
    
    public func onImageCaptured(
        _ type: String,
        _ count: Int,
        _ total: Int,
        _ imagePath: String,
        _ darkness: NSNumber?,
        _ lightness: NSNumber?,
        _ sharpness: NSNumber?
    ) {
        if let perseEventListener = self.perseEventListener {
            self.perseLite?.face.detect(imagePath) {
                detectResponse in
                
                perseEventListener.onImageCaptured(
                    count,
                    total,
                    imagePath,
                    detectResponse
                )
            } onError: {
                errorCode, message in
                
                self.onError(errorCode)
                
                perseEventListener.onImageCaptured(
                    count,
                    total,
                    imagePath,
                    nil
                )
            }
        }
    }
    
    public func onFaceDetected(
        _ x: Int,
        _ y: Int,
        _ width: Int,
        _ height: Int,
        _ leftEyeOpenProbability: NSNumber?,
        _ rightEyeOpenProbability: NSNumber?,
        _ smilingProbability: NSNumber?,
        _ headEulerAngleX: NSNumber?,
        _ headEulerAngleY: NSNumber?,
        _ headEulerAngleZ: NSNumber?
    ) {
        if let perseEventListener = self.perseEventListener {
            var leftEye: Bool {
                if let leftEyeOpenProbability = leftEyeOpenProbability?.floatValue {
                    return leftEyeOpenProbability > 0.8
                }
                return false
            }
            var rightEye: Bool {
                if let rightEyeOpenProbability = rightEyeOpenProbability?.floatValue {
                    return rightEyeOpenProbability > 0.8
                }
                return false
            }
            var smiling: Bool {
                if let smilingProbability = smilingProbability?.floatValue {
                    return smilingProbability > 0.8
                }
                return false
            }
            perseEventListener.onFaceDetected(
                x,
                y,
                width,
                height,
                leftEye,
                rightEye,
                smiling,
                self.getVertical(headEulerAngleX),
                self.getHorizontal(headEulerAngleY),
                self.getTilt(headEulerAngleZ)
            )
        }
    }
    
    private func getVertical(_ headEulerAngleX: NSNumber?) -> HeadMovement {
        if let angle = headEulerAngleX?.floatValue {
            if angle < -36 {
                return HeadMovement.VERTICAL_SUPER_DOWN
            } else if -36 < angle && angle < -12 {
                return HeadMovement.VERTICAL_DOWN
            } else if -12 < angle && angle < 12 {
                return HeadMovement.VERTICAL_DOWN
            } else if 12 < angle && angle < 36 {
                return HeadMovement.VERTICAL_UP
            } else if 36 < angle {
                return HeadMovement.VERTICAL_SUPER_UP
            }
        }
        return HeadMovement.UNDEFINED
    }
    
    private func getHorizontal(_ headEulerAngleY: NSNumber?) -> HeadMovement {
        if let angle = headEulerAngleY?.floatValue {
            if angle < -36 {
                return HeadMovement.HORIZONTAL_SUPER_LEFT
            } else if -36 < angle && angle < -12 {
                return HeadMovement.HORIZONTAL_LEFT
            } else if -12 < angle && angle < 12 {
                return HeadMovement.HORIZONTAL_NORMAL
            } else if 12 < angle && angle < 36 {
                return HeadMovement.HORIZONTAL_RIGHT
            } else if 36 < angle {
                return HeadMovement.HORIZONTAL_SUPER_RIGHT
            }
        }
        return HeadMovement.UNDEFINED
    }
    
    private func getTilt(_ headEulerAngleZ: NSNumber?) -> HeadMovement {
        if let angle = headEulerAngleZ?.floatValue {
            if angle < -36 {
                return HeadMovement.TILT_SUPER_RIGHT
            } else if -36 < angle && angle < -12 {
                return HeadMovement.TILT_RIGHT
            } else if -12 < angle && angle < 12 {
                return HeadMovement.TILT_NORMAL
            } else if 12 < angle && angle < 36 {
                return HeadMovement.TILT_LEFT
            } else if 36 < angle {
                return HeadMovement.TILT_SUPER_LEFT
            }
        }
        return HeadMovement.UNDEFINED
    }
    
    public func onFaceUndetected() {
        if let perseEventListener = self.perseEventListener {
            perseEventListener.onFaceUndetected()
        }
    }
    
    public func onEndCapture() {
        if let perseEventListener = self.perseEventListener {
            perseEventListener.onEndCapture()
        }
    }
    
    public func onError(_ error: String) {
        if let perseEventListener = self.perseEventListener {
            perseEventListener.onError(error)
        }
    }
    
    public func onMessage(_ message: String) {
        if let perseEventListener = self.perseEventListener {
            perseEventListener.onMessage(message)
        }
    }
    
    public func onPermissionDenied() {
        if let perseEventListener = self.perseEventListener {
            perseEventListener.onPermissionDenied()
        }
    }
    
    public func onQRCodeScanned(_ content: String) {
        if let perseEventListener = self.perseEventListener {
            perseEventListener.onQRCodeScanned(content)
        }
    }
}


