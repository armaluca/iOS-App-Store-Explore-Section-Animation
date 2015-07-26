# ionicons.swift
swift version of [ionicons-iOS](https://github.com/sweetmandm/ionicons-iOS) that easily use ionicons from swift project.

### About
The ionicons icon set includes a lot of iOS system icons as well as plenty of handy additions. The great thing about ionicons is it makes the system icons a lot handier and more customizable, while adding more icon options. Also, with ionicons-iOS you can use iOS 7 system icons in your native SDK iOS 5+ projects, so your designs will have a consistent appearance across all OS versions.

### Usage:

For available icons, look at [**ionicons** website](http://ionicons.com).


```swift
    // Render an ionicons icon in a UIImage:
    let image = UIImage.imageWithIonIcon(.arrow_up_b, height: 60, color: UIColor.brownColor())

    // directly use the ionicons font:
    let font = UIFont(name: "ionicons", size: 28)
```


### Installation:
1. Drag the folder 'ionicons' with the source files into your project
2. Modify your project's Info.plist file, add "ionicons.ttf" to the "Fonts provided by application" key