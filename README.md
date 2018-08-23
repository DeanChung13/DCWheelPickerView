# DCWheelPickerView

[![License: MIT](https://camo.githubusercontent.com/29a2cc0b8b0b7a3d4e2b5455d8f2502fe301426b/68747470733a2f2f696d672e736869656c64732e696f2f636f636f61706f64732f6c2f4d4250726f67726573734855442e7376673f7374796c653d666c6174)](http://opensource.org/licenses/MIT)

`DCWheelPickerView` is a number picker that can pick number from 0 to 99. It supported dragging and tapping, you can interact the outer wheel or inner wheel with gesture.

![](./Gif/wheel_demo.gif)

## Adding DCWheelPickerView to your project

### Source files

directly add DCWheelPickerView folder to your project



## Usage

```swift
let wheelPicker = DCWheelPickerView(frame: containerView.bounds)
containerView.addSubview(wheelPicker)

wheelPicker.didSelectIndexCompletion = { (index) in
  print("DidSelectIndex: \(index)")
}
wheelPicker.didTapCenterCompletion = {
  print("DidTapCenter")
}
```



## License

This code is distributed under the terms and conditions of the [MIT license](https://github.com/DeanChung13/DCWheelPickerView/blob/master/LICENSE).