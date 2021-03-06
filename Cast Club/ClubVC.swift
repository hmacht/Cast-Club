import UIKit

class ClubVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var clubTabelView: UITableView!
    
    var userIds = [String]()
    var clubs = [Club]()
    
    var selectedClub = Club()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clubTabelView.delegate = self
        self.clubTabelView.dataSource = self
        
        self.clubTabelView.addRefreshCapability(target: self, selector: #selector(ClubVC.refreshClubs))
        
        clubTabelView.tableFooterView = UIView()
        //self.clubTabelView.separatorStyle = UITableViewCell.SeparatorStyle.none
        //clubTabelView.layoutMargins = UIEdgeInsets.zero
        //clubTabelView.separatorInset = UIEdgeInsets.zero
        
        self.clubTabelView.backgroundColor = UIColor(red: 246.0/255.0, green: 246.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        
        //self.view.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 247.0/255.0, alpha: 1.0)
        
        // Do any additional setup after loading the view.
        
        if CloudKitHelper.instance.isAuthenticated {
            self.tabBarController?.showActivity()
        }
        
        /*if clubIds == ["none"] && CloudKitHelper.instance.isAuthenticated {
            // Have not gotten club ids yet
            CloudKitHelper.instance.getClubIdsForCurrentUser { (ids, error) in
                if let e = error {
                    print(e)
                    self.tabBarController?.stopActivity()
                    self.tabBarController?.showError(with: e.localizedDescription)
                } else {
                    self.userIds = ids
                    if self.userIds.count == 0 {
                        self.tabBarController?.stopActivity()
                        self.tabBarController?.showNoResultsLabel(message: "You have not subscribed to any clubs yet!")
                    }
                    clubIds = ids
                    for id in self.userIds {
                        CloudKitHelper.instance.getClub(with: id, completion: { (club, error) in
                            self.clubs.append(club)
                            DispatchQueue.main.async {
                                self.tabBarController?.stopActivity()
                                self.clubTabelView.reloadData()
                            }
                        })
                    }
                }
            }
        } else if CloudKitHelper.instance.isAuthenticated {
            self.userIds = clubIds
            if self.userIds.count == 0 {
                self.tabBarController?.stopActivity()
                self.tabBarController?.showNoResultsLabel(message: "You have not subscribed to any clubs yet!")
            }
            for id in self.userIds {
                CloudKitHelper.instance.getClub(with: id, completion: { (club, error) in
                    self.clubs.append(club)
                    DispatchQueue.main.async {
                        self.tabBarController?.stopActivity()
                        self.clubTabelView.reloadData()
                    }
                })
            }
        } else {
            self.tabBarController?.stopActivity()
            self.tabBarController?.showNoResultsLabel(message: "When you log in, the clubs you follow will show up here!")
        }*/
        
        if CloudKitHelper.instance.isAuthenticated {
            CloudKitHelper.instance.getUserSubscribedClubsNoPic { (results) in
            
                if results.count == 0 {
                    DispatchQueue.main.async {
                        self.tabBarController?.stopActivity()
                        self.tabBarController?.showNoResultsLabel(message: "You have not subscribed to any clubs yet!")
                    }
                } else {
                    self.clubs = results
                    DispatchQueue.main.async {
                        self.tabBarController?.stopActivity()
                        //self.clubTabelView.reloadWithAnimation()
                        self.clubTabelView.reloadData()
                    }
                }
            }
        } else {
            self.tabBarController?.stopActivity()
            self.tabBarController?.showNoResultsLabel(message: "When you log in, the clubs you follow will show up here!")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Podcast Clubs"
        let yourBackImage = UIImage(named: "Group 29")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "Group 31"), style: .done, target: self, action: #selector(ClubVC.add))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "Group 916"), style: .done, target: self, action: #selector(ClubVC.playlist))
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        //self.navigationItem.leftBarButtonItem = leftBarButtonItem
        self.navigationItem.title = "Podcast Clubs"
        
        //let whiteAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
        //UIBarButtonItem.appearance().setTitleTextAttributes(whiteAttributes , for: .normal)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.userIds = clubIds
        self.clubs = clubs.filter({$0.subscribedUsers.contains(CloudKitHelper.instance.userId.recordName)})
        self.clubTabelView.reloadData()
        
        if !CloudKitHelper.instance.isAuthenticated {
            self.tabBarController?.showNoResultsLabel(message: "When you log in, the clubs you follow will show up here!")
        }
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.stopActivity()
        self.tabBarController?.hideNoResultsLabel()
        
        self.navigationItem.setHidesBackButton(false, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.clubs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    
    // Test Material
    var images = [UIImage(named: "Group 439"), UIImage(named: "img1"), UIImage(named: "img3"), UIImage(named: "img2")]
    var header = ["Club Name", "The longest Club Name", "Short", "Long Name"]
    var responces = ["News", "Everything", "Kids", "Science"]
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.clubTabelView.dequeueReusableCell(withIdentifier: "ClubCell", for:indexPath) as! ClubTableViewCell
        let club = self.clubs[indexPath.row]
        
        // Get cover photo
        cell.clubIMG.image = UIImage(named: "defaultImage")
        
        CloudKitHelper.instance.getClubCoverPhoto(id: club.id) { (image, url, error) in
            if error == nil {
                if let img = image {
                    club.coverImage = img
                    DispatchQueue.main.async {
                        cell.clubIMG.image = img
                    }
                }
                if let link = url {
                    club.imgUrl = link
                }
            }
        }
        
        cell.clubIMG.contentMode = .scaleAspectFill
        cell.clubName.text = club.name
        cell.catagoryLabel.text = club.category.rawValue
        
        cell.catagoryLabel.font = UIFont(name: "Avenir-Heavy", size: 12)
        cell.clubName.font = UIFont(name: "Avenir-Black", size: 16)
        
        /*if indexPath.row >= self.clubs.count {
         // Retrieve club data
         CloudKitHelper.instance.getClub(with: self.userIds[indexPath.row]) { (club, error) in
         if let e = error {
         print("error getting club")
         } else {
         self.clubs.append(club)
         print("Count", self.clubs.count)
         DispatchQueue.main.async {
         print(club.coverImage.size, club.name, club.category.rawValue)
         print("From array", self.clubs[indexPath.row].coverImage.size, self.clubs[indexPath.row].name)
         // TODO - Doesnt actually change labels for some reason just goes blank
         cell.clubIMG.image = club.coverImage
         cell.clubName.text = club.name
         cell.catagoryLabel.text = club.category.rawValue
         }
         }
         }
         } else {
         let club = self.clubs[indexPath.row]
         cell.clubIMG.image = club.coverImage
         cell.clubName.text = club.name
         cell.catagoryLabel.text = club.category.rawValue
         
         }*/
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedClub = self.clubs[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "toChat", sender: self)
        
    }
    
    
    
    
    
    let screenSize = UIScreen.main.bounds
    
    
    
    @objc func playlist() {
        print("playlist")
        
        
        
        
    }
    
    
    
    @objc func add() {
        
        if CloudKitHelper.instance.isAuthenticated {
            self.performSegue(withIdentifier: "create", sender: self)
        } else {
            self.tabBarController?.showError(with: "You must login to iCloud to create a Club.")
        }
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toChat" {
            if let destination = segue.destination as? ClubChatVC {
                destination.selectedClub = self.selectedClub
            }
        }
    }
    
    @objc func refreshClubs() {
        self.tabBarController?.hideNoResultsLabel()
        
        if CloudKitHelper.instance.isAuthenticated {
            CloudKitHelper.instance.getUserSubscribedClubsNoPic { (results) in
                
                DispatchQueue.main.async {
                    self.clubTabelView.refreshControl?.endRefreshing()
                }
                
                if results.count == 0 {
                    DispatchQueue.main.async {
                        self.tabBarController?.stopActivity()
                        self.tabBarController?.showNoResultsLabel(message: "You have not subscribed to any clubs yet!")
                    }
                } else {
                    self.clubs = results
                    DispatchQueue.main.async {
                        self.tabBarController?.stopActivity()
                        //self.clubTabelView.reloadWithAnimation()
                        self.clubTabelView.reloadData()
                    }
                }
            }
        } else {
            self.clubTabelView.refreshControl?.endRefreshing()
            self.tabBarController?.stopActivity()
            self.tabBarController?.showNoResultsLabel(message: "When you log in, the clubs you follow will show up here!")
        }
    }
    
    
    
    
}
