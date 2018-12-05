// # Proxy Compiler 18.9.3-e21ac4-20181026

import Foundation
import SAPOData

internal class DeliveryServiceStaticResolver {
    static func resolve() {
        DeliveryServiceStaticResolver.resolve1()
    }

    private static func resolve1() {
        Ignore.valueOf_any(DeliveryServiceMetadata.EntityTypes.deliveryStatusType)
        Ignore.valueOf_any(DeliveryServiceMetadata.EntityTypes.packagesType)
        Ignore.valueOf_any(DeliveryServiceMetadata.EntitySets.deliveryStatus)
        Ignore.valueOf_any(DeliveryServiceMetadata.EntitySets.packages)
        Ignore.valueOf_any(DeliveryStatusType.deliveryStatusID)
        Ignore.valueOf_any(DeliveryStatusType.packageID)
        Ignore.valueOf_any(DeliveryStatusType.location)
        Ignore.valueOf_any(DeliveryStatusType.deliveryTimestamp)
        Ignore.valueOf_any(DeliveryStatusType.statusType)
        Ignore.valueOf_any(DeliveryStatusType.selectable)
        Ignore.valueOf_any(DeliveryStatusType.status)
        Ignore.valueOf_any(PackagesType.packageID)
        Ignore.valueOf_any(PackagesType.name)
        Ignore.valueOf_any(PackagesType.description)
        Ignore.valueOf_any(PackagesType.price)
        Ignore.valueOf_any(PackagesType.deliveryStatus)
    }
}
