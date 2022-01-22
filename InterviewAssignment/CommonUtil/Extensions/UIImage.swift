//
//  UIImage.swift
//  InterviewAssignment
//
//  Created by Dheeraj's MacBook Pro on 2022-01-21.
//


import UIKit

extension UIImageView {

    func imageFromUrl(urlString: String) {
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() {
                    self.image = UIImage(data: data)
                }
            }
            task.resume()
        }
    }
}
