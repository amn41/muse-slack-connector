// AUTOGENERATED FILE - DO NOT MODIFY!
// This file generated by Djinni from packets.djinni

#import <Foundation/Foundation.h>

/**
 * @file
 * Enum represents all possible packet types.
 * The type of the packet tells you information about what data
 * is stored in 'values' field.
 * When you know the packet type, look at the corresponding enum for information
 * about data mapping (e.g.: Accelerometer enum, EEG enum, etc).
 */
typedef NS_ENUM(NSInteger, IXNMuseDataPacketType)
{
    /**
     * 3-axis accelerometer data packet
     * Size of the values array for this packet is always 3.
     * \if IOS_ONLY
     * Take a look at IXNAccelerometer.h for mapping details.
     * \endif
     * \if IOS_ANDROID
     * Take a look at Accelerometer enum for mapping details
     * \endif
     */
    IXNMuseDataPacketTypeAccelerometer,
    /**
     * Packet contains raw data from %Muse EEG sensors. Data mapping in
     * this packet is the same as in quantization packet.
     * Currently size of the values array is always 4 for this packet.
     * In the future new %Muse Presets may be added, which will have extra
     * values.
     * \if IOS_ONLY
     * Take a look at IXNEeg.h for mapping details.
     * \endif
     * \if IOS_ANDROID
     * Take a look at Eeg enum for mapping details.
     * \endif
     */
    IXNMuseDataPacketTypeEeg,
    /**
     * Packet stands in for n dropped samples of the un-dropped type.
     * This packet is sent before accelerometer data packet.
     * Size of the values array for this packet is always 1.
     */
    IXNMuseDataPacketTypeDroppedAccelerometer,
    /**
     * Packet stands in for n dropped samples of the un-dropped type.
     * This packet is sent before EEG data packet.
     * Size of the values array for this packet is always 3.
     */
    IXNMuseDataPacketTypeDroppedEeg,
    /**
     * Packet contains information about signal quantization.
     * Size of the values array for this packet is always equal to the size
     * of EEG packet and has the same channel mapping.
     *
     * Each index in this packet corresponds to the same index in an EEG packet.
     * Quantization occurs when there is a particularly noisy signal, which
     * generally happens when there is not a good contact between the headband
     * and the skin.
     *
     * Higher numbers are worse; 1 is no quantization, and 16 is maximum
     * quantization.
     *
     * These values are used under the hood by the library and by %Muse Elements
     * in reconstructing the EEG signal and contributing to an overall measure
     * of noise; it is extremely unlikely that you will be interested in them.
     * For measuring noise, it is recommended to instead use the more useful
     * computed values like 'headband_on' or 'horseshoe'.
     *
     * Each quantization packet applies to the next 16 EEG packets.
     */
    IXNMuseDataPacketTypeQuantization,
    /**
     * %Muse headband battery data packet.
     * \if IOS_ONLY
     * Take a look at IXNBattery.h for mapping details.
     * \endif
     * \if IOS_ANDROID
     * Take a look at Battery enum for mapping details.
     * \endif
     */
    IXNMuseDataPacketTypeBattery,
    /**
     * Packet contains raw data from %Muse DRL and REF sensors.
     * \if IOS_ONLY
     * Take a look at IXNDrlRef.h for mapping details.
     * \endif
     * \if IOS_ANDROID
     * Take a look at DrlRef enum for mapping details.
     * \endif
     */
    IXNMuseDataPacketTypeDrlRef,
    /**
     * Absolute alpha band powers for each channel.
     * Size of the values array for this packet is always equal to the size
     * of EEG packet and has the same channel mapping.
     */
    IXNMuseDataPacketTypeAlphaAbsolute,
    /**
     * Absolute beta band powers for each channel.
     * Size of the values array for this packet is always equal to the size
     * of EEG packet and has the same channel mapping.
     */
    IXNMuseDataPacketTypeBetaAbsolute,
    /**
     * Absolute delta band powers for each channel.
     * Size of the values array for this packet is always equal to the size
     * of EEG packet and has the same channel mapping.
     */
    IXNMuseDataPacketTypeDeltaAbsolute,
    /**
     * Absolute theta band powers for each channel.
     * Size of the values array for this packet is always equal to the size
     * of EEG packet and has the same channel mapping.
     */
    IXNMuseDataPacketTypeThetaAbsolute,
    /**
     * Absolute gamma band powers for each channel.
     * Size of the values array for this packet is always equal to the size
     * of EEG packet and has the same channel mapping.
     */
    IXNMuseDataPacketTypeGammaAbsolute,
    /**
     * Relative alpha band powers for each channel.
     * Values in this packet are in range [0; 1].
     * Size of the values array for this packet is always equal to the size
     * of EEG packet and has the same channel mapping.
     */
    IXNMuseDataPacketTypeAlphaRelative,
    /**
     * Relative beta band powers for each channel.
     * Values in this packet are in range [0; 1].
     * Size of the values array for this packet is always equal to the size
     * of EEG packet and has the same channel mapping.
     */
    IXNMuseDataPacketTypeBetaRelative,
    /**
     * Relative delta band powers for each channel.
     * Values in this packet are in range [0; 1].
     * Size of the values array for this packet is always equal to the size
     * of EEG packet and has the same channel mapping.
     */
    IXNMuseDataPacketTypeDeltaRelative,
    /**
     * Relative band powers for each channel.
     * Values in this packet are in range [0; 1].
     * Size of the values array for this packet is always equal to the size
     * of EEG packet and has the same channel mapping.
     */
    IXNMuseDataPacketTypeThetaRelative,
    /**
     * Relative band powers for each channel.
     * Values in this packet are in range [0; 1].
     */
    IXNMuseDataPacketTypeGammaRelative,
    /**
     * Alpha band power scores for each channel.
     * Size of the values array for this packet is always equal to the size
     * of EEG packet and has the same channel mapping.
     */
    IXNMuseDataPacketTypeAlphaScore,
    /**
     * Beta band power scores for each channel.
     * Size of the values array for this packet is always equal to the size
     * of EEG packet and has the same channel mapping.
     */
    IXNMuseDataPacketTypeBetaScore,
    /**
     * Delta band power scores for each channel.
     * Size of the values array for this packet is always equal to the size
     * of EEG packet and has the same channel mapping.
     */
    IXNMuseDataPacketTypeDeltaScore,
    /**
     * Theta band power scores for each channel.
     * Size of the values array for this packet is always equal to the size
     * of EEG packet and has the same channel mapping.
     */
    IXNMuseDataPacketTypeThetaScore,
    /**
     * Gamma band power scores for each channel.
     * Size of the values array for this packet is always equal to the size
     * of EEG packet and has the same channel mapping.
     */
    IXNMuseDataPacketTypeGammaScore,
    /**
     * Horseshoe values represent quality of signal
     * for each sensor (know as horseshoe indicator).
     * Size of the values array for this packet is always equal to the size
     * of EEG packet and has the same channel mapping.
     */
    IXNMuseDataPacketTypeHorseshoe,
    /** Artifacts packet type will be sent */
    IXNMuseDataPacketTypeArtifacts,
    /**
     * Packet contains only one "double" value, which is a mellow score,
     * calculated by %Muse Elements algorithm. Approximately 30 seconds are
     * required before algorithm will start producing correct values.
     * Range [0; 1]. This packet is experimental.
     */
    IXNMuseDataPacketTypeMellow,
    /**
     * Packet contains only one "double" value, which is a concentration score,
     * calculated by %Muse Elements algorithm. Approximately 30 seconds are
     * required before algorithm will start producing correct values.
     * Range [0; 1]. This packet is experimental.
     */
    IXNMuseDataPacketTypeConcentration,
    /** The total number of possible data packet types */
    IXNMuseDataPacketTypeTotal,
    IXNMuseDataPacketTypeCount,
};
