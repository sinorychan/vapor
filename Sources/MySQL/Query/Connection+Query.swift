import Async
import Foundation
import Core

extension Connection {
    /// Writes a query to the connection
    ///
    /// Doesn't handle anything else
    internal func write(query: String) throws {
        var buffer = Data()
        buffer.reserveCapacity(query.utf8.count + 1)
        
        // SQL Query
        buffer.append(0x03)
        buffer.append(contentsOf: [UInt8](query.utf8))
        
        try self.write(packetFor: buffer)
    }
}

extension ConnectionPool {
    /// Used to send queries that expect no concrete results
    ///
    /// http://localhost:8000/mysql/basics/#resultless-queries
    ///
    /// - returns: A future that is completed on query success or failure
    @discardableResult
    public func query(_ query: Query) -> Future<Void> {
        return self.allRows(in: query).map { _ in
            return ()
        }
    }
}