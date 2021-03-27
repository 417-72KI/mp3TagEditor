import Foundation

extension Mp3File {
    static let samples: [Mp3File] = {
        do {
            return try Bundle.main.paths(forResourcesOfType: "mp3", inDirectory: nil)
                .map(Mp3File.init(path:))
        } catch {
            logger.error(error)
            return []
        }
    }()
}
