//
//  RickAndMortyViewController.swift
//  Rick and Morty
//
//  Created by Tim on 9/29/20.
//  Copyright © 2020 Tim. All rights reserved.
//

import UIKit

class RickAndMortyViewController: UIViewController {
    let cache = NSCache<NSString, UIImage>()
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var rickAndMorty: [Results] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
        grabListOfNames()
    }
    
    
    func grabListOfNames() {
        
        let baseURL = "https://rickandmortyapi.com/api/character/?page=2"
        let rickAndMortyEndpoint = URL(string: baseURL)
        //            let randomFactEndpoint = URL(string: baseURL + "/images/search")
        guard let url = rickAndMortyEndpoint else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // First we are going to check to make sure there were no errors.
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            //Second, Check that the response is the correct type, and the the request was successful.
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                debugPrint("Server error")
                return
            }
            //Third, we are going to make sure we definitely have data
            guard let data = data else { return }
            let decoder = JSONDecoder()
            
            do {
                let decodedResult = try? decoder.decode(Root.self, from: data)
                self.rickAndMorty = decodedResult?.results ?? []
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }catch {
                debugPrint(error.localizedDescription)
            }
            
        }
        task.resume()
    }
    
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard let self = self,
                error == nil,
                let response = response as? HTTPURLResponse, response.statusCode == 200,
                let data = data,
                let image = UIImage(data: data) else {
                    completed(nil)
                    return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        
        task.resume()
    }
    
    
}

extension RickAndMortyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rickAndMorty.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RickAndMortyCharViewCell", for: indexPath) as! RickAndMortyCharViewCell
        let cover = rickAndMorty[indexPath.row].image
        self.downloadImage(from: cover) { image in
            DispatchQueue.main.async {
                cell.imageOutlet.image = image
            }
        }
        cell.nameLabel.text = "Name: " + rickAndMorty[indexPath.row].name
        cell.speciesLabel.text = "Species: " + rickAndMorty[indexPath.row].species
        cell.statusLabel.text = "Status: " + rickAndMorty[indexPath.row].status
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetail", sender: self)
    }
}
