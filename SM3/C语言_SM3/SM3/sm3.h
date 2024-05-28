#ifndef _SM3_H_
#define _SM3_H_

extern unsigned int sm3(
	unsigned char* ucpSrcData,
	unsigned int nSrcLen,
	unsigned char* ucpHash,
	unsigned int* nHashLen);

#endif
