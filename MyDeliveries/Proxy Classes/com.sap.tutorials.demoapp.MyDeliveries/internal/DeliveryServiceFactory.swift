// # Proxy Compiler 18.9.3-e21ac4-20181026

import Foundation
import SAPOData

internal class DeliveryServiceFactory {
    static func registerAll() throws {
        DeliveryServiceMetadata.EntityTypes.deliveryStatusType.registerFactory(ObjectFactory.with(create: { DeliveryStatusType(withDefaults: false) }, createWithDecoder: { d in try DeliveryStatusType(from: d) }))
        DeliveryServiceMetadata.EntityTypes.packagesType.registerFactory(ObjectFactory.with(create: { PackagesType(withDefaults: false) }, createWithDecoder: { d in try PackagesType(from: d) }))
        DeliveryServiceStaticResolver.resolve()
    }
}
