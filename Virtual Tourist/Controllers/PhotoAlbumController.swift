//
//  PhotoAlbumController.swift
//  Virtual Tourist
//
//  Created by Mohamed Shiha on 8/8/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotoAlbumController: UIViewController {

    // MARK: Properties
    let dataController = DataController.shared
    var pinCoordinate : CLLocationCoordinate2D!
    var images = [UIImage]()
    var pin : Pin!
    
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var newCollectionBtn: UIBarButtonItem!
    @IBOutlet weak var statusLabel: UILabel!
    
    // MARK: View Lifecylce
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
        
        mapView.region = MKCoordinateRegion(center: pinCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.075, longitudeDelta: 0.075))
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = pinCoordinate
        mapView.addAnnotation(annotation)
    
        pin = fetchPin()
        
        newCollectionBtn.isEnabled = false
        
        setupCollectionView()
        
        loadPhotos()
    }
    
    // MARK : Setup CollectionView Cell
    func setupCollectionView() {
        imagesCollectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "flickrPic")
        imagesCollectionView.backgroundColor = .white
        
        let space : CGFloat = 1.0
        let widthDimension = (view.frame.width - (2 * space)) / 3.0
        let heightDimension = (view.frame.height - (2 * space)) / 6.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: widthDimension, height: heightDimension)
    }
    
    // MARK : Fetch Album
    private func fetchAlbum() -> Album? {
        
        if let pin = self.pin {
            
            var album : Album? = nil
            
            if (pin.pinToAlbum?.allObjects.count)! >= 1 {
                album = pin.pinToAlbum?.allObjects[(pin.pinToAlbum?.allObjects.count)! - 1] as? Album
            }
            
            if album != nil {
                return album
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    private func fetchPin() -> Pin? {
        let latitude = round(pinCoordinate.latitude * 100000) / 100000
        let longitude = round(pinCoordinate.longitude * 100000) / 100000
        
        let pinPredicate = NSPredicate(format: "%K == %@ AND %K == %@", argumentArray:["latitude", "\(latitude)", "longitude", "\(longitude)"])
        
        let pin = Entity<Pin>.fetchPin(pinPredicate)
        
        if pin == nil {
            return nil
        }
        return pin
    }
    
    // MARK : Load Photos
    func loadPhotos() {
        
        let album = fetchAlbum()
        
        if album == nil {
            let bbox = "\(pinCoordinate.longitude - 1),\(pinCoordinate.latitude - 1),\(pinCoordinate.longitude + 1),\(pinCoordinate.latitude + 1)"
            downloadPhotos(bbox, pageNumber: 1)
        } else {
            images = (album?.images?.decodeFromCoreDataStore())!
            
            if images.count > 0 {
                enableAlbumUI()
            } else {
                disableAlbumUI()
            }
            print("Album with specified location already exists")
        }
    }
    
    // MARK : Download photos
    private func downloadPhotos(_ bbox : String, pageNumber : Int) {
        
        let queryParameters = [
            FlickrClient.QueryParamterKeys.bbox : bbox,
            FlickrClient.QueryParamterKeys.page : "\(pageNumber)"
        ]
        
        self.downloadingAlbumUI()
        
        FlickrClient.shared.getImages(queryParameters) { (images, error) in
            
            if let images = images {
                if images.count > 0 {
                    self.images = images
                    self.enableAlbumUI()
                    self.createAlbumRecord(images)
                } else {
                    self.disableAlbumUI()
                }
            } else {
                print(error!)
            }
        }
    }
    
    // MARK : Create DB Record
    func createAlbumRecord( _ images: [UIImage]) {
        
        if pin != nil {
            let newAlbum = Album(context: dataController.viewContext)
            newAlbum.images = images.encodeToCoreDataStore()
            
            pin?.addToPinToAlbum(newAlbum)
            
            try? dataController.viewContext.save()
        }
    }
    
    @IBAction func newCollectionButton(_ sender: Any) {
        images.removeAll()
        imagesCollectionView.reloadData()

        let randomPageNumber = Int.random(in: 1..<1000)
        let bbox = "\(pinCoordinate.longitude - 1),\(pinCoordinate.latitude - 1),\(pinCoordinate.longitude + 1),\(pinCoordinate.latitude + 1)"
        
        downloadPhotos(bbox, pageNumber: randomPageNumber)
    }
    
    // MARK : Update UI
    private func enableAlbumUI() {
        DispatchQueue.main.async {
            self.statusLabel.isHidden = true
            self.newCollectionBtn.isEnabled = true
            self.imagesCollectionView.reloadData()
        }
    }
    
    private func downloadingAlbumUI() {
        DispatchQueue.main.async {
            self.statusLabel.isHidden = false
            self.statusLabel.text = "Downloading..."
            self.statusLabel.textColor = #colorLiteral(red: 0.08235294118, green: 0.6392156863, blue: 0.8666666667, alpha: 1)
        }
    }
    
    private func disableAlbumUI() {
        DispatchQueue.main.async {
            self.statusLabel.text = "No Images"
            self.statusLabel.textColor = #colorLiteral(red: 1, green: 0.2705882353, blue: 0.2274509804, alpha: 1)
            self.statusLabel.isHidden = false
        }
    }
}


// MARK: MapView Stubs

extension PhotoAlbumController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseID = "pinView"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "pinView") as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView?.pinTintColor = .red
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
}


// MARK : CollectionView Stubs

extension PhotoAlbumController : UICollectionViewDelegate,UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "flickrPic", for: indexPath) as! ImageCollectionViewCell
        cell.generateCell(images[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let album = fetchAlbum()
        
        if album != nil {
            images.remove(at: indexPath.row)
            album?.setValue(images.encodeToCoreDataStore(), forKey: "images")
            try? dataController.viewContext.save()
            collectionView.reloadData()
        }
    }
}
