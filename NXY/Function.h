
#ifndef __FUNCTION_H__
#define __FUNCTION_H__

#include "globe.h"

#ifdef __cplusplus
extern "C" {
#endif

#ifndef WIN32
VOID itoa( CHAR * buf, INT base, INT d );
#endif

VOID CalculateMAC( BYTE * pData, UINT nLen, BYTE * pData1, BYTE * pData2 );

#ifdef __cplusplus
}
#endif

#endif

