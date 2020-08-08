import Foundation
import ReviewerFramework

let service = ITunesCustomerReviewsService()
service.reviewesJSON { (jsonString, error) in
    if let error = error {
        print(error)
        return
    }
    print(jsonString!)
    exit(0)
}

dispatchMain()
