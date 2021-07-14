
# Perse SDK iOS
From [CyberLabs.AI](https://cyberlabs.ai/).  
_Ready to go biometric verification for the internet._

The Perse CocoaPods SDK:
* Top notch facial detection model;
* Anti-spoofing;
* Feedback on image quality;
* Compare the similarity between two faces;
* Doesn't store any photos;
* [Camera](https://github.com/Yoonit-Labs/ios-yoonit-camera/) integration and abstraction;

For more details, you can see the [Official Perse](https://www.getperse.com/).

> #### Just need the API and not the camera integration?
> See the Perse [SDK Lite iOS](https://github.com/cyberlabsai/perse-sdk-lite-ios) version. 

> #### Soon voice biometric verification.

## Content of Table

* [About](#about)
* [Get Started](#get-started)
  * [Install](#install)
  * [Get API Key](#get-api-key)
  * [Demo](#demo)
* [Usage](#usage)
  * [Face Detect](#face-detect)
  * [Face Compare](#face-compare)
  * [Perse Camera](#perse-camera)
* [API](#api)
  * [Methods](#methods)
    * [face.detect](#face.detect)
    * [face.compare](#face.compare)
    * [Perse Camera Methods](#perse-camera-methods)
  * [Events](#events)
    * [PerseEventListener](#perseeventlistener)
      * [Head Movement](#head-movement)
  * [Responses](#responses)
  * [Errors](#errors)
* [To Contribute and Make It Better](#to-contribute-and-make-it-better)

## About

This SDK provides abstracts the communication with the Perse's API endpoints and also convert the response from json to a pre-defined [responses](#responses).

> #### Want to test the endpoints?
> You can test our endpoints using this [Swagger UI Playground](https://api.getperse.com/swagger/).

> #### Want to test a web live demo?
> You can test our web live demos in the [CyberLabs.AI CodePen](https://codepen.io/cyberlabsai) or in the [Perse Oficial Docs](https://docs.getperse.com/sdk-js/demo.html#authentication-demo
). Do not forget your [API Key](#get-api-key).

> #### Want to try a backend client?
> We have some examples in `Python`, `Go` and `javaScript`.
> You can see documented [here](https://docs.getperse.com/face-api/#introduction).

## Get Started

### Install

1. Create a [Podfile](https://guides.cocoapods.org/using/the-podfile.html). You may need install [CocoaPods](https://guides.cocoapods.org/using/getting-started.html#toc_3) in your environment.

2. Add the following line to your `Podfile` file:

```
pod 'Perse'
```

3. And run in the project root the following command line:

```
pod install
```

4. Now, you can open and build your project with the extension `.xcworkspace`;

> #### How to create a  Xcode project with CocoaPods?
> TO create a Xcode project with CocoaPods you can see in the [Official CocoaPods Guide](https://guides.cocoapods.org/using/using-cocoapods.html#creating-a-new-xcode-project-with-cocoapods).

### API Key

Perse API authenticates your requests using an API Key.  
We are currently in Alpha. So you can get your API Key:
1. Sending an email to [developer@getperse.com](mailto:%20developer@getperse.com);
2. Or in the Perse official site [https://www.getperse.com/](https://www.getperse.com/);

### Demo

We have a [Demo](/Example/PerseDemo)  in this repository for you:
* Feel free to change the Demo code; 
* Not forget to get your [API KEY](#api-key); 
* To run, the Demo, it is necessary to follow the [Install](#install) steps;

## Usage

### Face Detect

Detect allows you process images with the intent of detecting human faces.

```swift
import Perse
import PerseLite

func detect(_ file: String) {
    let perse = Perse(apiKey: "API_KEY")

    perse.face.detect(filePath) {
        detectResponse in
        debugPrint(detectResponse)
    } onError: {
        status, error in
        
        debugPrint(status)
    }
}
```

### Face Compare

Compare accepts two sources for similarity comparison.

```swift
import Perse
import PerseLite

func compare(
    _ firstFile: String,
    _ secondFile: String
) {
    let perse = Perse(apiKey: "API_KEY")

    perse.face.compare(
        firstFilePath,
        secondFilePath
    ) {
        compareResponse in
        debugPrint(compareResponse)
    } onError: {
        status, error in
        
        debugPrint(status)
    }
}
```

### Perse Camera

The Perse Camera:
* in essence, is the abstraction of the integration between the [PerseLite](https://github.com/cyberlabsai/perse-sdk-lite-ios) and the [Yoonit Camera](https://github.com/Yoonit-Labs/ios-yoonit-camera/);
* Must use the [PerseEventListener](#perse-event-listener);
* Works partially without an API Key;
* Must have a [API Key](#get-api-key) to receive the [Responses](#responses);

Here we have a example in code how to detect a face from a camera. See the complete code in the [Demo](/Example/PerseDemo) application.

```swift
import UIKit
import Perse
import PerseLite

class PerseCameraViewController:
    UIViewController,
    PerseEventListener
{
    @IBOutlet var perseCamera: PerseCamera!

    override func viewDidLoad() {
        super.viewDidLoad()
            
        self.perseCamera.apiKey = Environment.apiKey
        self.perseCamera.perseEventListener = self
        self.perseCamera.startPreview()
    }

    func onImageCaptured(
        _ count: Int,
        _ total: Int,
        _ imagePath: String,
        _ detectResponse: DetectResponse?
    ) {
        debugPrint(detectResponse)
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
    ) {}
    
    func onFaceUndetected() {}
    
    func onEndCapture() {}
    
    func onError(_ error: String) {
        debugPrint(error)
    }
    
    func onMessage(_ message: String) {}
    
    func onPermissionDenied() {}
    
    func onQRCodeScanned(_ content: String) {}    
}
```

## API

This section describes the Perse SDK iOS API's, [methods](#methods), your [responses](#responses) and possible [errors](#errors).

### Methods

The Perse is in `alpha` version and for now, only the `Face` module is available.

#### face.detect

* Has the intent of detecting any number of human faces;
* Can use this resource to evaluate the overall quality of the image;
* The input can be the image file path or his [Data](https://developer.apple.com/documentation/foundation/data);
* The `onSuccess` return type is [DetectResponse](#detectresponse) struct;
* The `onError` return type can see in the [Errors](#errors);

```swift
func detect(
    _ filePath: String,
    onSuccess: @escaping (DetectResponse) -> Void,
    onError: @escaping (String, String) -> Void
)
```

```swift
func detect(
    _ data: Data,
    onSuccess: @escaping (DetectResponse) -> Void,
    onError: @escaping (String, String) -> Void
)
```

#### face.compare

* Accepts two sources for similarity comparison;
* The inputs can be the image file paths or his [Data's](https://developer.apple.com/documentation/foundation/data);
* The `onSuccess` return type is [CompareResponse](#compareresponse) struct;
* The `onError` return type can see in the [Errors](#errors);

```swift
func compare(
    _ firstFilePath: String,
    _ secondFilePath: String,
    onSuccess: @escaping (CompareResponse) -> Void,
    onError: @escaping (String, String) -> Void
)
```

```swift
func compare(
    _ firstFile: Data,
    _ secondFile: Data,
    onSuccess: @escaping (CompareResponse) -> Void,
    onError: @escaping (String, String) -> Void
)
```

> #### Tip
> We recommend considering a match when similarity is above `71`.

#### Perse Camera Methods

| Function                        | Parameters                                                                    | Valid values                                                                      | Return Type | Description
| -                               | -                                                                             | -                                                                                 | -           | -  
| startPreview              | -                                                                             | -                                                                                 | void        | Start camera preview if has permission.
| startCaptureType          | `captureType: String`                                                         | <ul><li>`"none"`</li><li>`"face"`</li><li>`"qrcode"`</li><li>`"frame"`</li></ul> | void        | Set capture type none, face, QR Code or frame.
| stopCapture               | -                                                                             | -                                                                                 | void        | Stop any type of capture.
| destroy | - | - | void | Destroy camera preview.
| toggleCameraLens          | -                                                                             | -                                                                                 | void        | Toggle camera lens facing front/back.
| setCameraLens             | `cameraLens: String`        | <ul><li>`"front"`</li><li>`"back"`</li></ul>                                      | void         | Set camera to use "front" or "back" lens. Default value is "front".
| getCameraLens             | -                                                                             | -                                                                                 | String         | Return "front" or "back". 
| setNumberOfImages         | `numberOfImages: Int`                                                         | Any positive `Int` value                                                          | void        | Default value is 0. For value 0 is saved infinity images. When saved images reached the "number os images", the `onEndCapture` is triggered.
| setTimeBetweenImages      | `timeBetweenImages: Int64`                                                     | Any positive number that represent time in milli seconds                          | void        | Set saving face/frame images time interval in milli seconds.
| setOutputImageWidth       | `width: Int`                                                                  | Any positive `number` value that represents in pixels                             | void        | Set face image width to be created in pixels.
| setOutputImageHeight      | `height: Int`                                                                 | Any positive `number` value that represents in pixels                             | void        | Set face image height to be created in pixels.
| setSaveImageCaptured      | `enable: Bool`                                                     | `true` or `false`                                                                 | void        | Set to enable/disable save image when capturing face and frame.
| setDetectionBox | `enable: Bool` | `true` or `false` | void | Set to enable/disable detection box when face/qrcode detected. The detection box is the the face/qrcode bounding box normalized to UI.
| setDetectionBoxColor | `alpha: Float, red: Float, green: Float, blue: Float`   | Value between `0` and `1` | void | Set detection box ARGB color. Default value is `(0.4, 1.0, 1.0, 1.0)`.
| setDetectionMinSize  | `minimumSize: Float` | Value between `0` and `1`. Represents the percentage. | void | Set face/qrcode minimum size to detect in percentage related with the camera preview.
| setDetectionMaxSize | `maximumSize: Float` | Value between `0` and `1`. Represents the percentage. | void | Set face/qrcode maximum size to detect in percentage related with the camera preview.
| setFaceContours              | `enable: Bool`                                  | `true` or `false`                                                               | void        | Set to enable/disable face contours when face detected. 
| setFaceContoursColor | `alpha: Float, red: Float, green: Float, blue: Float`   | Value between `0` and `1` | void        | Set face contours ARGB color. Default value is `(0.4, 1.0, 1.0, 1.0)`.  
| setROI             | `enable: Bool`               | `true` or `false`                                                              | void        | Enable/disable the region of interest capture.
| setROITopOffset        | `topOffset: Float`       | Value between `0` and `1`. Represents the percentage. | void | Camera preview top distance in percentage. 
| setROIRightOffset     | `rightOffset: Float`   | Value between `0` and `1`. Represents the percentage. | void | Camera preview right distance in percentage.
| setROIBottomOffset | `bottomOffset: Float` | Value between `0` and `1`. Represents the percentage. | void | Camera preview bottom distance in percentage.
| setROILeftOffset       | `leftOffset: Float`     | Value between `0` and `1`. Represents the percentage. | void | Camera preview left distance in percentage.
| setROIAreaOffset | `enable: Bool` | `true` or `false` | void | Set to enable/disable region of interest offset visibility.
| setROIAreaOffsetColor | `alpha: Float, red: Float, green: Float, blue: Float` | Value between `0` and `1` | void | Set face region of interest area offset color. Default value is `(0.4, 1.0, 1.0, 1.0)`.
| setTorch | `enable: Bool` | `true` or `false` | void | Set to enable/disable the device torch. Available only to camera lens `"back"`.

### Events

#### PerseEventListener

| Event                     | Parameters                                                | Description
| -                            | -                                                         | -
| onImageCaptured | `type: String, count: Int, total: Int, imagePath: String, detectResponse: DetectResponse?` | Emitted when the image file is created: <ul><li>count: current index</li><li>total: total to create</li><li>imagePath: the image path</li><li>detectResponse: Is the [DetectResponse](#DetectResponse). Can be `nil` if not provided API Key.</li><ul>  
| onFaceDetected | `x: Int, y: Int, width: Int, height: Int, leftEyeOpen: Bool, rightEyeOpen: Bool, smiling: Bool, headVerticalMovement: HeadMovement, headHorizontalMovement: HeadMovement, headTiltMovement: HeadMovement` | Emit the [Head Movement](#head-movement).
| onFaceUndetected | -                                                         | Emitted after `onFaceDetected`, when there is no more face detecting.
| onEndCapture | -                                                         | Emitted when the number of image files created is equal of the number of images set (see the method `setNumberOfImages`).   
| onQRCodeScanned | `content: String`                                         | Must have started capture type of qrcode (see `startCaptureType`). Emitted when the camera scan a QR Code.   
| onError | `error: String`                                           | Emit message error.
| onMessage | `message: String`                                         | Emit message.
| onPermissionDenied | -                                                         | Emit when try to `startPreview` but there is not camera permission.

##### Head Movement

The `HeadMovement` is the response send by the `onFaceDetected`. Represents the head movement:  
* Vertical;
* Horizontal;
* Tilt;

Here we specify all the parameters:

| Attribute                             | Description
| -                                         | -
| UNDEFINED | Undefined head movement.
| VERTICAL_UP | Head movement vertical is pointing up.
| VERTICAL_SUPER_UP | Head movement vertical is pointing super up.
| VERTICAL_NORMAL | Head movement vertical normal.
| VERTICAL_DOWN | Head movement vertical is pointing down.
| VERTICAL_SUPER_DOWN |  Head movement vertical is pointing super up.
| HORIZONTAL_LEFT |  Head movement horizontal is pointing left.
| HORIZONTAL_SUPER_LEFT | Head movement horizontal is pointing super left.
| HORIZONTAL_NORMAL |  Head movement horizontal normal.
| HORIZONTAL_RIGHT | Head movement horizontal is pointing right.
| HORIZONTAL_SUPER_RIGHT | Head movement horizontal is pointing super right.
| TILT_LEFT | Head movement tilt is pointing left. 
| TILT_SUPER_LEFT | Head movement tilt is pointing super left.
| TILT_NORMAL | Head movement tilt normal.
| TILT_RIGHT | Head movement tilt is pointing right.
| TILT_SUPER_RIGHT | Head movement tilt is pointing super right.

### Responses

#### CompareResponse

| Attribute  | Type            | Description
| -          | -               | -
| similarity | `Float`         | Similarity between faces. Closer to `1` is better.
| timeTaken  | `Float`         | Time taken to analyze the image.

#### DetectResponse

| Attribute    | Type                                | Description
| -            | -                                   | -
| totalFaces   | `Int`                               | Total of faces in the image.
| faces        | `Array<FaceResponse>`               | Array of [FaceResponse](#faceresponse).
| imageMetrics | [MetricsResponse](#metricsresponse) | Metrics of the detected image.
| timeTaken    | `Float`                             | Time taken to analyze the image.

#### FaceResponse

| Attribute   | Type                                    | Description
| -           | -                                       | -
| landmarks   | [LandmarksResponse](#landmarksresponse) |  Detected face landmarks.
| boundingBox | `Array<Int>`                            | Array with the four values of the face bounding box. The coordinates `x`, `y` and the dimension `width` and `height` respectively.
| faceMetrics | [MetricsResponse](#metricsresponse)     | Metrics of the detecting face.
| livenessScore | `Long`                                  | Confidence that a detected face is from a live person (1 means higher confidence).

#### MetricsResponse

| Attribute   | Type    | Description
| -           | -       | -
| underexpose | `Float` | Indicates loss of shadow detail. Closer to `0` is better.
| overexpose  | `Float` | Indicates loss of highlight detail. Closer to `0` is better.
| sharpness   | `Float` | Indicates intensity of motion blur. Closer to `1` is better.

#### LandmarksResponse

| Attribute  | Type         | Description
| -          | -            | -
| rightEye   | `Array<Int>` | Right eye landmarks.
| leftEye    | `Array<Int>` | Left eye landmarks.
| nose       | `Array<Int>` | Nose landmarks.
| mouthRight | `Array<Int>` | Right side of mouth landmarks.
| mouthLeft  | `Array<Int>` | Left side of mouth landmarks.

### Errors

| Error Code | Description
| -                 | -
| 400            | The request was unacceptable, often due to missing a required parameter.
| 401            | API key is missing or invalid.
| 402            | The parameters were valid but the request failed.
| 415            | The content type or encoding is not valid.

## To Contribute and Make It Better

Clone the repo, change what you want and send PR.  
For commit messages we use <a href="https://www.conventionalcommits.org/">Conventional Commits</a>.

Contributions are always welcome!

---

Made with ❤ by the [**Cyberlabs AI**](https://cyberlabs.ai/)
