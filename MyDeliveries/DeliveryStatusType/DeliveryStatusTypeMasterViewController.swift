//
// DeliveryStatusTypeMasterViewController.swift
// MyDeliveries
//
// Created by SAP Cloud Platform SDK for iOS Assistant application on 04/12/18
//

import Foundation
import SAPCommon
import SAPFiori
import SAPFoundation
import SAPOData

class DeliveryStatusTypeMasterViewController: FUIFormTableViewController, SAPFioriLoadingIndicator {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var deliveryService: DeliveryService<OnlineODataProvider> {
        return self.appDelegate.deliveryService
    }

    public var loadEntitiesBlock: ((_ completionHandler: @escaping ([DeliveryStatusType]?, Error?) -> Void) -> Void)?
    private var entities: [DeliveryStatusType] = [DeliveryStatusType]()
    private let logger = Logger.shared(named: "DeliveryStatusTypeMasterViewControllerLogger")
    private let okTitle = NSLocalizedString("keyOkButtonTitle",
                                            value: "OK",
                                            comment: "XBUT: Title of OK button.")
    var loadingIndicator: FUILoadingIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        // Add refreshcontrol UI
        self.refreshControl?.addTarget(self, action: #selector(self.refresh), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(self.refreshControl!)
        // Cell height settings
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.register(FUITimelineCell.self, forCellReuseIdentifier:"FUITimelineCell")
        self.tableView.register(FUITimelineMarkerCell.self, forCellReuseIdentifier: "FUITimelineMarkerCell")
        self.tableView.estimatedRowHeight = 44
        self.tableView.backgroundColor = UIColor.preferredFioriColor(forStyle: .backgroundBase)
        self.tableView.separatorStyle = .none
        self.updateTable()
    }

    var preventNavigationLoop = false
    var entitySetName: String?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return self.entities.count
    }

    override func tableView(_: UITableView, canEditRowAt _: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let deliveryStatusType = self.entities[indexPath.row]
        if deliveryStatusType.selectable != 0 {
            return timelineCell(representing: deliveryStatusType, forRowAt: indexPath)
        } else {
            return timelineMarkerCell(representing: deliveryStatusType, forRowAt: indexPath)
        }
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        return formatter
    }()
    
    private func timelineMarkerCell(representing deliveryStatusType: DeliveryStatusType, forRowAt indexPath: IndexPath) -> FUITimelineMarkerCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FUITimelineMarkerCell", for: indexPath) as! FUITimelineMarkerCell
        
        cell.nodeImage = nodeImage(for: deliveryStatusType)
        cell.showLeadingTimeline = indexPath.row != 0
        cell.showTrailingTimeline = indexPath.row != (self.entities.count - 1)
        cell.eventText = dateFormatter.string(from: deliveryStatusType.deliveryTimestamp!.utc())
        cell.titleText = deliveryStatusType.status
        
        return cell
    }
    
    private func timelineCell(representing deliveryStatusType: DeliveryStatusType, forRowAt indexPath: IndexPath) -> FUITimelineCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FUITimelineCell", for: indexPath) as! FUITimelineCell
        
        cell.nodeImage = nodeImage(for: deliveryStatusType)
        cell.eventText = dateFormatter.string(from: deliveryStatusType.deliveryTimestamp!.utc())
        cell.headlineText = deliveryStatusType.status
        cell.subheadlineText = deliveryStatusType.location
        
        return cell
    }
    
    private func nodeImage(for deliveryStatusType: DeliveryStatusType) -> UIImage {
        switch deliveryStatusType.statusType! {
        case "start"    : return FUITimelineNode.start
        case "inactive" : return FUITimelineNode.inactive
        case "complete" : return FUITimelineNode.complete
        case "earlyEnd" : return FUITimelineNode.earlyEnd
        case "end"      : return FUITimelineNode.end
        default         : return FUITimelineNode.open
        }
    }
    


    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle != .delete {
            return
        }
        let currentEntity = self.entities[indexPath.row]
        self.deliveryService.deleteEntity(currentEntity) { error in
            if let error = error {
                self.logger.error("Delete entry failed.", error: error)
                let alertController = UIAlertController(title: NSLocalizedString("keyErrorDeletingEntryTitle", value: "Delete entry failed", comment: "XTIT: Title of deleting entry error pop up."), message: error.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: self.okTitle, style: .default))
                OperationQueue.main.addOperation({
                    // Present the alertController
                    self.present(alertController, animated: true)
                })
            } else {
                self.entities.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }

    // MARK: - Data accessing

    func requestEntities(completionHandler: @escaping (Error?) -> Void) {
        self.loadEntitiesBlock!() { entities, error in
            if let error = error {
                completionHandler(error)
                return
            }
            self.entities = entities!
            completionHandler(nil)
        }
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == "showDetail" {
            // Show the selected Entity on the Detail view
            guard let indexPath = self.tableView.indexPathForSelectedRow else {
                return
            }
            self.logger.info("Showing details of the chosen element.")
            let selectedEntity = self.entities[indexPath.row]
            let detailViewController = segue.destination as! DeliveryStatusTypeDetailViewController
            detailViewController.entity = selectedEntity
            detailViewController.navigationItem.leftItemsSupplementBackButton = true
            detailViewController.navigationItem.title = self.entities[(self.tableView.indexPathForSelectedRow?.row)!].deliveryStatusID ?? ""
            detailViewController.allowsEditableCells = false
            detailViewController.tableUpdater = self
            detailViewController.preventNavigationLoop = self.preventNavigationLoop
            detailViewController.entitySetName = self.entitySetName
        } else if segue.identifier == "addEntity" {
            // Show the Detail view with a new Entity, which can be filled to create on the server
            self.logger.info("Showing view to add new entity.")
            let dest = segue.destination as! UINavigationController
            let detailViewController = dest.viewControllers[0] as! DeliveryStatusTypeDetailViewController
            detailViewController.title = NSLocalizedString("keyAddEntityTitle", value: "Add Entity", comment: "XTIT: Title of add new entity screen.")
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: detailViewController, action: #selector(detailViewController.createEntity))
            detailViewController.navigationItem.rightBarButtonItem = doneButton
            let cancelButton = UIBarButtonItem(title: NSLocalizedString("keyCancelButtonToGoPreviousScreen", value: "Cancel", comment: "XBUT: Title of Cancel button."), style: .plain, target: detailViewController, action: #selector(detailViewController.cancel))
            detailViewController.navigationItem.leftBarButtonItem = cancelButton
            detailViewController.allowsEditableCells = true
            detailViewController.tableUpdater = self
            detailViewController.entitySetName = self.entitySetName
        }
    }

    // MARK: - Table update

    func updateTable() {
        self.showFioriLoadingIndicator()
        let oq = OperationQueue()
        oq.addOperation({
            self.loadData {
                self.hideFioriLoadingIndicator()
            }
        })
    }

    private func loadData(completionHandler: @escaping () -> Void) {
        self.requestEntities { error in
            defer {
                completionHandler()
            }
            if let error = error {
                let alertController = UIAlertController(title: NSLocalizedString("keyErrorLoadingData", value: "Loading data failed!", comment: "XTIT: Title of loading data error pop up."), message: error.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: self.okTitle, style: .default))
                OperationQueue.main.addOperation({
                    // Present the alertController
                    self.present(alertController, animated: true)
                })
                self.logger.error("Could not update table. Error: \(error)", error: error)
                return
            }
            OperationQueue.main.addOperation({
                self.tableView.reloadData()
                self.logger.info("Table updated successfully!")
            })
        }
    }

    @objc func refresh() {
        let oq = OperationQueue()
        oq.addOperation({
            self.loadData {
                OperationQueue.main.addOperation({
                    self.refreshControl?.endRefreshing()
                })
            }
        })
    }
}

extension DeliveryStatusTypeMasterViewController: EntitySetUpdaterDelegate {
    func entitySetHasChanged() {
        self.updateTable()
    }
}
