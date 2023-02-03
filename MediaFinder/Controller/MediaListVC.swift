//
//  MediaListVC.swift
//  MediaFinder
//
//  Created by Karim Mohamed on 27/12/2022.
//

import UIKit
import Alamofire
import AVKit
import SDWebImage

class MediaListVC: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var mediaTableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var segmentController: UISegmentedControl!
    
    // MARK: - Variables & properties
//    var arrOfImages: [String] = ["1","2"]
//    var arrOfName: [String] = ["Action","No Time To Die"]
//    var arrOfDescription: [String] = ["Action Movie", "Action Movie"]
    var mediaArr : [Media] = []
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Homepage"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Profile", style: .done, target: self, action:  #selector(goToProfile) )
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        mediaTableView.register(UINib(nibName: "MediaListCell", bundle: nil), forCellReuseIdentifier: "MediaListCell")
        mediaTableView.dataSource = self
        mediaTableView.delegate = self
        searchBar.delegate = self
    }
    
    // MARK: - Actions
    @IBAction func segmentSelectedTapped(_ sender: UISegmentedControl) {
        segmentedControl(segmentController)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: true)
        
    }

}

// MARK: - Private Methods // SearchBar
extension MediaListVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getData(term: searchBar.text!, media: segmentedControl(segmentController))
    }
    
}

// MARK: - Private Methods
extension MediaListVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediaArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MediaListCell", for: indexPath) as! MediaListCell
        
        if segmentController.selectedSegmentIndex == 0 {
            cell.imageView?.sd_setImage(with: URL(string: mediaArr[indexPath.row].artworkUrl))
            cell.cellTitleLabel.text = mediaArr[indexPath.row].trackName
            cell.cellDescriptionLabel.text = mediaArr[indexPath.row].longDescription
        }else if segmentController.selectedSegmentIndex == 1 {
            cell.imageView?.sd_setImage(with: URL(string: mediaArr[indexPath.row].artworkUrl))
            cell.cellTitleLabel.text = mediaArr[indexPath.row].artistName
            cell.cellDescriptionLabel.text = mediaArr[indexPath.row].longDescription
        }else {
            cell.imageView?.sd_setImage(with: URL(string: mediaArr[indexPath.row].artworkUrl))
            cell.cellTitleLabel.text = mediaArr[indexPath.row].trackName
            cell.cellDescriptionLabel.text = mediaArr[indexPath.row].longDescription
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = mediaArr[indexPath.row].previewUrl{
            privewUrl(url)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func privewUrl(_ stringUrl: String)
    {
        guard let url = URL(string: stringUrl) else {return}
        let player = AVPlayer(url: url)
        let vc = AVPlayerViewController()
        vc.player = player
        present(vc,animated: true) {
            vc.player?.play()
        }
    }
    
    private func segmentedControl(_ sender: UISegmentedControl) -> String{
        let index = sender.selectedSegmentIndex
        switch index {
        case 0:
            return "movie"
        case 1 :
            return "movie"
        case 2:
            return "music"
        default:
            return "default"
        }
    }
    @objc private func goToProfile(sender: AnyObject){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getData(term:String,media:String) {
        APIManager.search(term: term, media: media) { (error, mediaData) in
            if let error = error {
                print(error.localizedDescription)
            }else if let mediaData = mediaData {
                self.mediaArr = mediaData
                self.mediaTableView.reloadData()
            }
        }
    }
}
