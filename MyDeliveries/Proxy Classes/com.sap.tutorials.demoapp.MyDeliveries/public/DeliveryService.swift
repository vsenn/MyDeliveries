// # Proxy Compiler 18.9.3-e21ac4-20181026

import Foundation
import SAPOData

open class DeliveryService<Provider: DataServiceProvider>: DataService<Provider> {
    public override init(provider: Provider) {
        super.init(provider: provider)
        self.provider.metadata = DeliveryServiceMetadata.document
    }

    @available(swift, deprecated: 4.0, renamed: "fetchDeliveryStatus")
    open func deliveryStatus(query: DataQuery = DataQuery()) throws -> Array<DeliveryStatusType> {
        return try self.fetchDeliveryStatus(matching: query)
    }

    @available(swift, deprecated: 4.0, renamed: "fetchDeliveryStatus")
    open func deliveryStatus(query: DataQuery = DataQuery(), completionHandler: @escaping (Array<DeliveryStatusType>?, Error?) -> Void) {
        self.fetchDeliveryStatus(matching: query, headers: nil, options: nil, completionHandler: completionHandler)
    }

    open func fetchDeliveryStatus(matching query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> Array<DeliveryStatusType> {
        let var_query: DataQuery = DataQuery.newIfNull(query: query)
        let var_headers: HTTPHeaders = HTTPHeaders.emptyIfNull(headers: headers)
        let var_options: RequestOptions = try RequestOptions.noneIfNull(options: options)
        return try DeliveryStatusType.array(from: self.executeQuery(var_query.fromDefault(DeliveryServiceMetadata.EntitySets.deliveryStatus), headers: var_headers, options: var_options).entityList())
    }

    open func fetchDeliveryStatus(matching query: DataQuery = DataQuery(), headers: HTTPHeaders? = nil, options: RequestOptions? = nil, completionHandler: @escaping (Array<DeliveryStatusType>?, Error?) -> Void) {
        self.addBackgroundOperationForFunction {
            do {
                let result: Array<DeliveryStatusType> = try self.fetchDeliveryStatus(matching: query, headers: headers, options: options)
                self.completionQueue.addOperation {
                    completionHandler(result, nil)
                }
            } catch let error {
                self.completionQueue.addOperation {
                    completionHandler(nil, error)
                }
            }
        }
    }

    open func fetchDeliveryStatusType(matching query: DataQuery, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> DeliveryStatusType {
        let var_headers: HTTPHeaders = HTTPHeaders.emptyIfNull(headers: headers)
        let var_options: RequestOptions = try RequestOptions.noneIfNull(options: options)
        return try CastRequired<DeliveryStatusType>.from(self.executeQuery(query.fromDefault(DeliveryServiceMetadata.EntitySets.deliveryStatus), headers: var_headers, options: var_options).requiredEntity())
    }

    open func fetchDeliveryStatusType(matching query: DataQuery, headers: HTTPHeaders? = nil, options: RequestOptions? = nil, completionHandler: @escaping (DeliveryStatusType?, Error?) -> Void) {
        self.addBackgroundOperationForFunction {
            do {
                let result: DeliveryStatusType = try self.fetchDeliveryStatusType(matching: query, headers: headers, options: options)
                self.completionQueue.addOperation {
                    completionHandler(result, nil)
                }
            } catch let error {
                self.completionQueue.addOperation {
                    completionHandler(nil, error)
                }
            }
        }
    }

    open func fetchPackages(matching query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> Array<PackagesType> {
        let var_query: DataQuery = DataQuery.newIfNull(query: query)
        let var_headers: HTTPHeaders = HTTPHeaders.emptyIfNull(headers: headers)
        let var_options: RequestOptions = try RequestOptions.noneIfNull(options: options)
        return try PackagesType.array(from: self.executeQuery(var_query.fromDefault(DeliveryServiceMetadata.EntitySets.packages), headers: var_headers, options: var_options).entityList())
    }

    open func fetchPackages(matching query: DataQuery = DataQuery(), headers: HTTPHeaders? = nil, options: RequestOptions? = nil, completionHandler: @escaping (Array<PackagesType>?, Error?) -> Void) {
        self.addBackgroundOperationForFunction {
            do {
                let result: Array<PackagesType> = try self.fetchPackages(matching: query, headers: headers, options: options)
                self.completionQueue.addOperation {
                    completionHandler(result, nil)
                }
            } catch let error {
                self.completionQueue.addOperation {
                    completionHandler(nil, error)
                }
            }
        }
    }

    open func fetchPackagesType(matching query: DataQuery, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> PackagesType {
        let var_headers: HTTPHeaders = HTTPHeaders.emptyIfNull(headers: headers)
        let var_options: RequestOptions = try RequestOptions.noneIfNull(options: options)
        return try CastRequired<PackagesType>.from(self.executeQuery(query.fromDefault(DeliveryServiceMetadata.EntitySets.packages), headers: var_headers, options: var_options).requiredEntity())
    }

    open func fetchPackagesType(matching query: DataQuery, headers: HTTPHeaders? = nil, options: RequestOptions? = nil, completionHandler: @escaping (PackagesType?, Error?) -> Void) {
        self.addBackgroundOperationForFunction {
            do {
                let result: PackagesType = try self.fetchPackagesType(matching: query, headers: headers, options: options)
                self.completionQueue.addOperation {
                    completionHandler(result, nil)
                }
            } catch let error {
                self.completionQueue.addOperation {
                    completionHandler(nil, error)
                }
            }
        }
    }

    @available(swift, deprecated: 4.0, renamed: "fetchPackages")
    open func packages(query: DataQuery = DataQuery()) throws -> Array<PackagesType> {
        return try self.fetchPackages(matching: query)
    }

    @available(swift, deprecated: 4.0, renamed: "fetchPackages")
    open func packages(query: DataQuery = DataQuery(), completionHandler: @escaping (Array<PackagesType>?, Error?) -> Void) {
        self.fetchPackages(matching: query, headers: nil, options: nil, completionHandler: completionHandler)
    }

    open override func refreshMetadata() throws {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        do {
            try ProxyInternal.refreshMetadata(service: self, fetcher: nil, options: DeliveryServiceMetadataParser.options)
            DeliveryServiceMetadataChanges.merge(metadata: self.metadata)
        }
    }
}
