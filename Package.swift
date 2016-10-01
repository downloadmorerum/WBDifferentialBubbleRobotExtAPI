import PackageDescription

let package = Package(
    name: "WBDifferentialBubbleRobot",
    dependencies: [
        .Package(url: "https://github.com/mipalgu/CGUSimpleWhiteboard.git", majorVersion: 1),
        .Package(url: "https://github.com/mipalgu/CExtAPI.git", majorVersion: 1)
    ]
)
