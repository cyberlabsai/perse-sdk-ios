import UIKit
import Perse
import PerseLite

class PerseCameraViewController:
    UIViewController,
    UINavigationControllerDelegate,
    PerseEventListener
{
    @IBOutlet var perseCamera: PerseCamera!
    @IBOutlet var faceImageView: UIImageView!
    @IBOutlet var leftEyeIcon: UIImageView!
    @IBOutlet var rightEyeIcon: UIImageView!
    @IBOutlet var smilingIcon: UIImageView!
    @IBOutlet var horizontalMovementLabel: UILabel!
    @IBOutlet var verticalMovementLabel: UILabel!
    @IBOutlet var tiltMovementLabel: UILabel!
    @IBOutlet var faceUnderexposeIcon: UIImageView!
    @IBOutlet var faceSharpnessIcon: UIImageView!
    @IBOutlet var imageUnderexposeIcon: UIImageView!
    @IBOutlet var imageSharpnessIcon: UIImageView!
    var image: UIImage?
        
    override func viewDidLoad() {
        super.viewDidLoad()
                                           
        self.reset()
                
        self.perseCamera.perse = Perse(
            apiKey: Environment.apiKey,
            baseUrl: Environment.baseUrl
        )
        self.perseCamera.perseEventListener = self
        self.perseCamera.startPreview()
        self.perseCamera.setDetectionBox(true)
        self.perseCamera.setFaceContours(true)
    }
        
    func onImageCaptured(
        _ count: Int,
        _ total: Int,
        _ imagePath: String,
        _ detectResponse: PerseAPIResponse.Face.Detect?
    ) {
        let subpath = imagePath
            .substring(
                from: imagePath.index(
                    imagePath.startIndex,
                    offsetBy: 7
                )
            )
        let image = UIImage(contentsOfFile: subpath)
        self.faceImageView.image = image
        
        guard let detectResponse = detectResponse else {
            self.reset()
            return
        }
        
        if detectResponse.totalFaces == 0 {
            self.reset()
            return
        }

        self.faceImageView.image = image
        let face: PerseAPIResponse.Face.Face = detectResponse.faces[0]
        
        self.setSpoofingValidation(valid: face.livenessScore >= detectResponse.defaultThresholds.liveness)
        self.faceUnderexposeIcon.validate(valid: face.faceMetrics.underexposure > detectResponse.defaultThresholds.underexposure)
        self.faceSharpnessIcon.validate(valid: face.faceMetrics.sharpness < detectResponse.defaultThresholds.sharpness)
        self.imageUnderexposeIcon.validate(valid: detectResponse.imageMetrics.underexposure > detectResponse.defaultThresholds.underexposure)
        self.imageSharpnessIcon.validate(valid: detectResponse.imageMetrics.sharpness < detectResponse.defaultThresholds.sharpness)
    }
    
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
    ) {
        self.leftEyeIcon.validate(valid: leftEyeOpen)
        self.rightEyeIcon.validate(valid: rightEyeOpen)
        self.smilingIcon.validate(valid: smiling)
            
        switch headVerticalMovement {
        case .VERTICAL_SUPER_UP:
            self.verticalMovementLabel.text = "Super Up"
            break
        case .VERTICAL_UP:
            self.verticalMovementLabel.text = "Up"
            break
        case .VERTICAL_NORMAL:
            self.verticalMovementLabel.text = "Normal"
            break
        case .VERTICAL_DOWN:
            self.verticalMovementLabel.text = "Down"
            break
        case .VERTICAL_SUPER_DOWN:
            self.verticalMovementLabel.text = "Super Down"
            break
        default:
            break
        }
        
        switch headHorizontalMovement {
        case .HORIZONTAL_SUPER_LEFT:
            self.horizontalMovementLabel.text = "Super Left"
            break
        case .HORIZONTAL_LEFT:
            self.horizontalMovementLabel.text = "Left"
            break
        case .HORIZONTAL_NORMAL:
            self.horizontalMovementLabel.text = "Normal"
            break
        case .HORIZONTAL_RIGHT:
            self.horizontalMovementLabel.text = "Right"
            break
        case .HORIZONTAL_SUPER_RIGHT:
            self.horizontalMovementLabel.text = "Super Right"
            break
        default:
            break
        }
        
        switch headTiltMovement {
        case .TILT_SUPER_LEFT:
            self.tiltMovementLabel.text = "Super Left"
            break
        case .TILT_LEFT:
            self.tiltMovementLabel.text = "Left"
            break
        case .TILT_NORMAL:
            self.tiltMovementLabel.text = "Normal"
            break
        case .TILT_RIGHT:
            self.tiltMovementLabel.text = "Right"
            break
        case .TILT_SUPER_RIGHT:
            self.tiltMovementLabel.text = "Super Right"
            break
        default:
            break
        }
    }
    
    func onFaceUndetected() {
        self.reset()
    }
    
    func onEndCapture() {}
    
    func onError(_ error: String) {
        debugPrint(error)
    }
    
    func onMessage(_ message: String) {}
    
    func onPermissionDenied() {}
    
    func onQRCodeScanned(_ content: String) {}
    
    func setSpoofingValidation(valid: Bool) {
        valid
            ? self.perseCamera.setDetectionBoxColor(
                1,
                0.1882352941,
                0.8196078431,
                0.3450980392
            )
            : self.perseCamera.setDetectionBoxColor(1.0, 1, 0, 0)
        valid
            ? self.perseCamera.setFaceContoursColor(
                1,
                0.1882352941,
                0.8196078431,
                0.3450980392
            )
            : self.perseCamera.setFaceContoursColor(1.0, 1, 0, 0)
    }
    
    func reset() {
        self.faceImageView.image = nil
                
        self.leftEyeIcon.reset()
        self.rightEyeIcon.reset()
        self.smilingIcon.reset()
        self.horizontalMovementLabel.text = "-"
        self.verticalMovementLabel.text = "-"
        self.tiltMovementLabel.text = "-"
        self.faceUnderexposeIcon.reset()
        self.faceSharpnessIcon.reset()
        self.imageUnderexposeIcon.reset()
        self.imageSharpnessIcon.reset()
        self.perseCamera.setDetectionBoxColor(0, 1, 1, 1)
        self.perseCamera.setFaceContoursColor(0, 1, 1, 1)
    }
}

extension Float {
    func toLabel() -> String {
        return "\(String(format: "%.2f", self * 100))%"
    }
    
    func toText() -> String {
        return "\(String(format: "%.2f", self))"
    }
}

extension UIImageView {
    func validate(valid: Bool) {
        self.image = valid
            ? UIImage(systemName: "checkmark.circle.fill")
            : UIImage(systemName: "multiply.circle.fill")
        self.tintColor = valid
            ? UIColor.systemGreen
            : UIColor.systemRed
    }
    
    func reset() {
        self.image = UIImage(systemName: "minus.circle.fill")
        self.tintColor = UIColor.gray
    }
}
