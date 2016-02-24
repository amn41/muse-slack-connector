import Foundation

var ConcentrationScore : Double = 0.0

class LoggingListener: IXNMuseDataListener, IXNMuseConnectionListener {

    weak var _delegate: AppDelegate? = nil
    
    init(withDelegate delegate: AppDelegate) {
        self._delegate = delegate
    }
    
    @objc func receiveMuseConnectionPacket(packet: IXNMuseConnectionPacket){
        print("Connection packet received")
    }
    
    @objc func receiveMuseDataPacket(packet: IXNMuseDataPacket){
        print("Data packet received")
        print(packet)
        switch (packet.packetType) {
        case IXNMuseDataPacketType.Concentration :
            //print("concentration packet: \(packet.values[0])")
            ConcentrationScore = packet.values[0] as! Double
            print(ConcentrationScore)
        default :
            break
        }
    }
    @objc func receiveMuseArtifactPacket(packet: IXNMuseArtifactPacket){
        print("Artifact packet received")
        print(packet)
    }
}
