package utils

import "encoding/binary"

func Int32ToByteArray(value int32) []byte {
	byteArray := make([]byte, 4)
	binary.BigEndian.PutUint32(byteArray, uint32(value))
	return byteArray
}

func MergeByteArray(a, b []byte) []byte {
	merged := make([]byte, len(a)+len(b))
	copy(merged, a)
	copy(merged[len(a):], b)
	return merged
}
