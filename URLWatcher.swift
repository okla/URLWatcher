import Foundation

extension URL {
  var contents: AsyncStream<[String]?>? {
    guard let charPath = path.cString(using: .utf8) else {
      return nil
    }

    let descriptor = open(charPath, O_EVTONLY)
    guard descriptor != -1 else {
      return nil
    }

    return AsyncStream([String]?.self) { continuation in
      let eventSource = DispatchSource.makeFileSystemObjectSource(fileDescriptor: descriptor,
                                                                  eventMask: .all, queue: .main)
      eventSource.setCancelHandler {
        close(descriptor)
      }

      continuation.onTermination = { _ in
        eventSource.cancel()
      }

      func yieldContents() {
        continuation.yield(try? FileManager.default.contentsOfDirectory(atPath: path))
      }

      eventSource.setRegistrationHandler(handler: yieldContents)
      eventSource.setEventHandler(handler: yieldContents)
      eventSource.activate()
    }
  }
}
