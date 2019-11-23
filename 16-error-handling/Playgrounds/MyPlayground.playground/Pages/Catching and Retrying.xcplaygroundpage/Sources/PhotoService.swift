import Combine
import UIKit


// MARK: - Service
public class PhotoService {
    private var retries = 0
    
    public init() {}
    
    public func fetchPhoto(
        quality: Quality,
        failingTimes: Int = .max
    ) -> PhotoService.Publisher {
        Publisher(quality: quality, failingTimes: failingTimes)
    }
}


// MARK: - Custom Publisher
public extension PhotoService {
    
    class Publisher: Combine.Publisher {
        public typealias Output = UIImage
        public typealias Failure = PhotoService.Error
        
        private let quality: PhotoService.Quality
        private let failingTimes: Int
        private var retries = -1
        
        public init(quality: PhotoService.Quality, failingTimes: Int = .max) {
            self.quality = quality
            self.failingTimes = failingTimes
        }
        
        public func receive<S: Subscriber>(subscriber: S)
            where Failure == S.Failure,
            Output == S.Input
        {
            retries += 1
                
            let subscription = Subscription(
                quality: quality,
                shouldFail: failingTimes != 0 && retries < failingTimes,
                subscriber: subscriber
            )
            
            subscriber.receive(subscription: subscription)
        }
    }
}

private extension PhotoService.Publisher {
    
    class Subscription<S: Subscriber>: Combine.Subscription
        where S.Input == UIImage,
        S.Failure == PhotoService.Publisher.Failure
    {
        private let quality: PhotoService.Quality
        private let shouldFail: Bool
        private let subscriber: S
        
        public init(quality: PhotoService.Quality, shouldFail: Bool, subscriber: S) {
            self.quality = quality
            self.shouldFail = shouldFail
            self.subscriber = subscriber
        }
        
        
        func request(_ demand: Subscribers.Demand) {
            let randomDelay = TimeInterval.random(in: 0.5...2.5)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + randomDelay) { [weak self] in
                guard let self = self else { return }
                
                switch self.quality {
                case .high:
                    guard self.shouldFail else {
                        _ = self.subscriber.receive(UIImage(named: "hq.jpg")!)
                        self.subscriber.receive(completion: .finished)
                        return
                    }
                    
                    self.subscriber.receive(completion: .failure(.failedFetching(self.quality)))
                case .low:
                    _ = self.subscriber.receive(UIImage(named: "lq.jpg")!)
                    self.subscriber.receive(completion: .finished)
                }
            }
        }
        
        func cancel() {
            subscriber.receive(completion: .finished)
        }
        
        var combineIdentifier: CombineIdentifier {
            return CombineIdentifier(self)
        }
    }
}


extension PhotoService {
    public enum Quality {
        case high
        case low
    }
    
    public enum Error: Swift.Error, CustomStringConvertible {
        case failedFetching(Quality)
        
        public var description: String {
            switch self {
            case .failedFetching(let quality):
                return "Failed fetching image with \(quality) quality"
            }
        }
    }
}
