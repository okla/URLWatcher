# URLWatcher
Lightweight URL contents watcher using Swift AsyncStream

## Installation
Add URLWatcher.swift to your project

## Usage
```swift
if let documentsContents = FileManager.default.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first?.contents {
  for await contents in documentsContents {
    print(contents)
  }
}
```
