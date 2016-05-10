// TCPSSLConnection.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Zewo
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

@_exported import TCP
@_exported import OpenSSL

public struct TCPSSLConnection: Connection {
    public let connection: TCPConnection
    public let stream: SSLClientStream

    public init(host: String, port: Int, verifyBundle: String? = nil, certificate: String? = nil, privateKey: String? = nil, certificateChain: String? = nil, SNIHostname: String? = nil) throws {
        print("** Creating TCP connection to \(host):\(port)")
        self.connection = try TCPConnection(host: host, port: port)
        print("** Creating context")
        let context = try SSLClientContext(
            verifyBundle: verifyBundle,
            certificate: certificate,
            privateKey: privateKey,
            certificateChain: certificateChain
        )
        print("** Creating client stream")
        self.stream = try SSLClientStream(context: context, rawStream: connection, SNIHostname: SNIHostname)
        print("** Done")
    }

    public func open(timingOut deadline: Double) throws {
        try connection.open(timingOut: deadline)
    }

    public var closed: Bool {
        return stream.closed
    }

    public func receive(upTo byteCount: Int, timingOut deadline: Double) throws -> Data {
        return try stream.receive(upTo: byteCount, timingOut: deadline)
    }

    public func send(_ data: Data, timingOut deadline: Double) throws {
        try stream.send(data, timingOut: deadline)
    }

    public func flush(timingOut deadline: Double) throws {
        try stream.flush(timingOut: deadline)
    }

    public func close() throws {
        try stream.close()
    }
}
