//
//  TestViewController.swift
//  BusApp
//
//  Created by Jozo Knez on 2019-12-05.
//  Copyright © 2019 Ali Muhammad. All rights reserved.
//



/*
 
 The code from this view controller was modeled around an existing solution that was made available through a GitHub project found here:
 https://github.com/SCENEE/FloatingPanel/blob/master/Examples/Maps/Maps/Base.lproj/Main.storyboard
 This projects mimics our intent to have a view that displays a 'floating' table that can link to a particular view. The code provided in the link was very helpful in providing a framework to build a solution.
 
 The purpose of that project was to create a view (eg. a map view as the main view) with a specific feature that allowed a second view (eg. table view) to be placed with it together on the same screen. We wanted to have this feature (that is also increasingly prevalent within a number of other App store applications like 'stocks', since it would allow the user to quickly navigate between views while allowing the information to remain in the same screen. The specific features of this functionality were implemented by using a CocoaPod named 'FloatingPanel' provided by the author in the link.
 
 
 
 */


// 'FloatingPanel pod was installed in the project through the Podfile
import UIKit
import MapKit
import FloatingPanel

// FloatingPanelControllerDelegate outlines several methods used to move the table
// that overlays on top of the mapview
class TestViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate, FloatingPanelControllerDelegate {
    
    
    
    var fpc: FloatingPanelController!
    var searchVC: SearchPanelViewController!

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // instantiate a floating panel object and provide a reference to it
        // within the view
        fpc = FloatingPanelController()
        fpc.delegate = self

        // Initialize fpc and add it to view
        fpc.surfaceView.backgroundColor = .clear
        
        // use of a preprocessor directive
        // styling purposes
        // can't tell the difference if I comment this out
        if #available(iOS 11, *) {
            fpc.surfaceView.cornerRadius = 9.0
        }
        
        else {
            fpc.surfaceView.cornerRadius = 0.0
        }
        fpc.surfaceView.shadowHidden = false

        searchVC = storyboard?.instantiateViewController(withIdentifier: "SearchPanel") as? SearchPanelViewController

        // Set a content view controller
        fpc.set(contentViewController: searchVC)
        fpc.track(scrollView: searchVC.tableView)

        // primary view of the page is an initial map view
        setupMapView()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // add the floating panel object to the existing view
        fpc.addPanel(toParent: self, animated: true)

        // required or else generate error
        searchVC.searchBar.delegate = self
    
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        destroyMapView()
    }

    func setupMapView() {
        // oakville default 
        let center = CLLocationCoordinate2D(latitude: 43.464060,
                                            longitude: -79.685220)
        
        
        let span = MKCoordinateSpan(latitudeDelta: 0.4,
                                    longitudeDelta: 0.25)
        
        
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.region = region
        mapView.showsCompass = true
        mapView.showsUserLocation = true
        mapView.delegate = self
    }
    
    func destroyMapView() {
        // required or else get error
        mapView.delegate = nil
        mapView = nil
    }

    // UISearchBarDelegate methods
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton  = false
        
        searchVC.hideTopViewOfTable()
        
        fpc.move(to: .half, animated: true)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        searchVC.showTopViewOfTable()
        searchVC.tableView.alpha = 1.0
        fpc.move(to: .full, animated: true)
    }

    // FloatingPanelControllerDelegate methods
    
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        
        switch newCollection.verticalSizeClass {
        
        case .compact:
            fpc.surfaceView.borderWidth = 1.0 / traitCollection.displayScale
            fpc.surfaceView.borderColor = UIColor.black.withAlphaComponent(0.2)
            return SearchPanelLandscapeLayout()
        
        
        default:
            fpc.surfaceView.borderWidth = 0.0
            fpc.surfaceView.borderColor = nil
            return nil
        }
    }

    func floatingPanelDidMove(_ vc: FloatingPanelController) {
        
        let y = vc.surfaceView.frame.origin.y
        let deltaY = vc.originYOfSurface(for: .tip)
        
        // hardcoded values that will compile if changed
        // but do not have any noticeable effects
        // more time required to investigate and try
        // to optimize these settings
        
        if y > deltaY - 44.0 {
            let progress = max(0.0, min((deltaY  - y) / 44.0, 1.0))
            self.searchVC.tableView.alpha = progress
        }
    }

    
    func floatingPanelWillBeginDragging(_ vc: FloatingPanelController) {
        if vc.position == .full {
            
            searchVC.searchBar.showsCancelButton = false
            searchVC.searchBar.resignFirstResponder()
        }
    }

    func floatingPanelDidEndDragging(_ vc: FloatingPanelController, withVelocity velocity: CGPoint, targetPosition: FloatingPanelPosition) {
        if targetPosition != .full {
            
            searchVC.hideTopViewOfTable()
        }

        UIView.animate(withDuration: 0.2,
                       delay: 0.0,
                       options: .allowUserInteraction,
                       animations: {
                        if targetPosition == .tip {
                            self.searchVC.tableView.alpha = 0.0
                        } else {
                            self.searchVC.tableView.alpha = 1.0
                        }
                        
        }, completion: nil)
    }
}


class SearchPanelViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!

    
    //var ref : DatabaseReference!
    var dbContactList = [Contacts]()
    private lazy var shadowLayer: CAShapeLayer = CAShapeLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.placeholder = "Search for a place or address"
        searchBar.setSearchText(fontSize: 15.0)

        hideTopViewOfTable()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        visualEffectView.layer.cornerRadius = 9.0
        visualEffectView.clipsToBounds = true

        // adding shawow effects
        view.layer.insertSublayer(shadowLayer, at: 0)
        let rect = visualEffectView.frame
        
        
        // UIBelzierPath: is a path that consists of straight and curved line segments that you can render in your custom views (Apple developer site)
        
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: 9.0, height: 9.0))
        shadowLayer.frame = visualEffectView.frame
        shadowLayer.shadowPath = path.cgPath
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        shadowLayer.shadowOpacity = 0.2
        shadowLayer.shadowRadius = 3.0
   
    }

    /*
    func LoadContacts() {
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").queryOrdered(byChild: "email").queryEqual(toValue: email!).observe(.childAdded, with: { (snapshot) in
                    let results = snapshot.value as? [String : AnyObject]
                    let email = results?["email"]
                    
                    let dbContacts = Contacts(contactType: type as! String?)
                    self.myContactList.append(dbContacts)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
            })
    }
   */
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return dbContactList.count
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        
        if let cell = cell as? TableCell {
            
            // this is an implementation that is geared to the demo
            // we would want to call LoadContacts() method here to get
            // contacts from the database
            // could not debug issues in time for project submission
            // work is ongoing
            switch indexPath.row {
            case 0:
                cell.picImageView.image = UIImage(named: "caroline.jpg")
                cell.nameLabel.text = "Candice"
                cell.emailLabel.text = "candice@gmail.org"
            case 1:
                cell.picImageView.image = UIImage(named: "ferb1.jpg")
                cell.nameLabel.text = "Ferb"
                cell.emailLabel.text = "ferb@ferb.net"
            case 2:
                cell.picImageView.image = UIImage(named: "perry.png")
                cell.nameLabel.text = "Perry"
                cell.emailLabel.text = "perry@platypus.com"
            case 3:
                cell.picImageView.image = UIImage(named: "phineusnew.jpg")
                cell.nameLabel.text = "Phineus"
                cell.emailLabel.text = "phineus@phineus.net"
            
            default:
                break
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let more = UITableViewRowAction(style: .normal, title: "More", handler: {
            action, index in
                print("more button tapped")})
        
        more.backgroundColor = .lightGray
        // this won't work here
        //more.image = UIImage(named: "")
        
        
        let favourite = UITableViewRowAction(style: .normal, title: "Favourite", handler: {
            action, index in
                print("favourite button tapped")
        })
        
        favourite.backgroundColor = .orange
        
        return [more, favourite]
        
    }
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal, title: "Delete", handler: {
            ac, view, success in
                print("Delete button tapped")
                success(true)
        })
        delete.backgroundColor = .red
        delete.image = UIImage(named: "trashbin.png")
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func showTopViewOfTable() {
        // hard coded value for height based on
        // example implementation that was used previously
        changeTopViewOfTable(height: 116.0)
    }

    func hideTopViewOfTable() {
        changeTopViewOfTable(height: 0.0)
    }

    func changeTopViewOfTable(height: CGFloat) {
        
        tableView.beginUpdates()
        
        
        if let headerView = tableView.tableHeaderView  {
            UIView.animate(withDuration: 0.2) {
                var frame = headerView.frame
                frame.size.height = height
                self.tableView.tableHeaderView?.frame = frame
            }
        }
        tableView.endUpdates()
    }
}

// the landscape layout was included in this particular project because
// we are able to demonstrate the intended functionality of the 'FloatPanel'
// within that view. One of the problems that we are having in the development
// of the app is that the 'FloatPanel' does not always work while in the portrait
// view but does function regularly in the landscape view

public class SearchPanelLandscapeLayout: FloatingPanelLayout {
    public var initialPosition: FloatingPanelPosition {
        return .tip
    }
    
    public var supportedPositions: Set<FloatingPanelPosition> {
        return [.full, .tip]
    }

    public func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full: return 16.0
        case .tip: return 69.0
        default: return nil
        }
    }

    public func prepareLayout(surfaceView: UIView, in view: UIView) -> [NSLayoutConstraint] {
        
        // preprocessor directive that checks for a specific version of the OS
        if #available(iOS 11.0, *) {
            return [
                surfaceView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8.0),
                surfaceView.widthAnchor.constraint(equalToConstant: 275),
            ]
        } else {
            return [
                surfaceView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8.0),
                surfaceView.widthAnchor.constraint(equalToConstant: 275),
            ]
        }
    }

    public func backdropAlphaFor(position: FloatingPanelPosition) -> CGFloat {
        return 0.0
    }
}


// define the view in the table cell

class TableCell: UITableViewCell {
    @IBOutlet weak var picImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
}


class Contacts {

    var contactName: String?
    var contactEmail: String?
    var contactImage: Int?

    init(contactName: String?, contactEmail: String?, contactImage: Int?) {
        self.contactName = contactName
        self.contactEmail = contactEmail
        self.contactImage = contactImage
    }
}





// placeholder view in the associated table view in order to
// give it additional visual features
// future implementation could make this segment more interactive
// in terms of switching the views that the table represents
class SearchHeaderView: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.clipsToBounds = true
    }
}

// must maintain this extension or else geta crash
// still tracing functionality
extension UISearchBar {
    func setSearchText(fontSize: CGFloat) {
        
        // preprocessor directives (before compile time)
        // if you comment these out then app will crash
        #if swift(>=5.1)
            let font = searchTextField.font
            searchTextField.font = font?.withSize(fontSize)
        #else
            let textField = value(forKey: "_searchField") as! UITextField
            textField.font = textField.font?.withSize(fontSize)
        #endif
    }
}


