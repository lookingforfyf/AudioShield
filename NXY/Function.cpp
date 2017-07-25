
#include "Function.h"
#include <string.h>

#ifndef WIN32
#include <stdint.h>
#include <errno.h>
#include <ctype.h>
/*
 * Convert a string to an intmax_t
 *
 * Ignores `locale' stuff.  Assumes that the upper and lower case
 * alphabets and digits are each contiguous.
 */
static intmax_t strtoimax( const char * nptr, char ** endptr, int base )
{
	const char *s;
	intmax_t acc, cutoff;
	int c;
	int neg, any, cutlim;

	/*
	 * Skip white space and pick up leading +/- sign if any.
	 * If base is 0, allow 0x for hex and 0 for octal, else
	 * assume decimal; if base is already 16, allow 0x.
	 */
	s = nptr;
	do {
		c = (unsigned char) *s++;
	} while (isspace(c));
	if (c == '-') {
		neg = 1;
		c = *s++;
	} else {
		neg = 0;
		if (c == '+')
			c = *s++;
	}
	if ((base == 0 || base == 16) &&
	    c == '0' && (*s == 'x' || *s == 'X')) {
		c = s[1];
		s += 2;
		base = 16;
	}
	if (base == 0)
		base = c == '0' ? 8 : 10;

	/*
	 * Compute the cutoff value between legal numbers and illegal
	 * numbers.  That is the largest legal value, divided by the
	 * base.  An input number that is greater than this value, if
	 * followed by a legal input character, is too big.  One that
	 * is equal to this value may be valid or not; the limit
	 * between valid and invalid numbers is then based on the last
	 * digit.  For instance, if the range for intmax_t is
	 * [-9223372036854775808..9223372036854775807] and the input base
	 * is 10, cutoff will be set to 922337203685477580 and cutlim to
	 * either 7 (neg==0) or 8 (neg==1), meaning that if we have
	 * accumulated a value > 922337203685477580, or equal but the
	 * next digit is > 7 (or 8), the number is too big, and we will
	 * return a range error.
	 *
	 * Set any if any `digits' consumed; make it negative to indicate
	 * overflow.
	 */

	/* BIONIC: avoid division and module for common cases */
#define  CASE_BASE(x) \
            case x:  \
	        if (neg) { \
                    cutlim = INTMAX_MIN % x; \
		    cutoff = INTMAX_MIN / x; \
	        } else { \
		    cutlim = INTMAX_MAX % x; \
		    cutoff = INTMAX_MAX / x; \
		 }; \
		 break

	switch (base) {
            case 4:
                if (neg) {
                    cutlim = (int)(INTMAX_MIN % 4);
                    cutoff = INTMAX_MIN / 4;
                } else {
                    cutlim = (int)(INTMAX_MAX % 4);
                    cutoff = INTMAX_MAX / 4;
                }
                break;

	    CASE_BASE(8);
	    CASE_BASE(10);
	    CASE_BASE(16);
	    default:
	              cutoff  = neg ? INTMAX_MIN : INTMAX_MAX;
		      cutlim  = cutoff % base;
	              cutoff /= base;
	}
#undef CASE_BASE

	if (neg) {
		if (cutlim > 0) {
			cutlim -= base;
			cutoff += 1;
		}
		cutlim = -cutlim;
	}
	for (acc = 0, any = 0;; c = (unsigned char) *s++) {
		if (isdigit(c))
			c -= '0';
		else if (isalpha(c))
			c -= isupper(c) ? 'A' - 10 : 'a' - 10;
		else
			break;
		if (c >= base)
			break;
		if (any < 0)
			continue;
		if (neg) {
			if (acc < cutoff || (acc == cutoff && c > cutlim)) {
				any = -1;
				acc = INTMAX_MIN;
				errno = ERANGE;
			} else {
				any = 1;
				acc *= base;
				acc -= c;
			}
		} else {
			if (acc > cutoff || (acc == cutoff && c > cutlim)) {
				any = -1;
				acc = INTMAX_MAX;
				errno = ERANGE;
			} else {
				any = 1;
				acc *= base;
				acc += c;
			}
		}
	}
	if (endptr != 0)
		*endptr = (char *) (any ? s - 1 : nptr);
	return (acc);
}

static int atoi( const char * s )
{
	return ( int )strtoimax( s, NULL, 16 );
}

/* Convert the integer D to a string and save the string in BUF. If
   BASE is equal to 'd', interpret that D is decimal, and if BASE is
   equal to 'x', interpret that D is hexadecimal.  */
void itoa( char * buf, int base, int d )
{
	char * p         = buf;
	char * p1        = NULL;
	char * p2        = NULL;
	unsigned long ud = d;
	int divisor      = 10;

	/* If %d is specified and D is minus, put `-' in the head.  */
	if ( base == 'd' && d < 0 )
	{
		*p++ = '-';
		buf++;
		ud = -d;
	}
	else if ( base == 'x' )
		divisor = 16;

	/* Divide UD by DIVISOR until UD == 0.  */
	do
	{
		int remainder = ud % divisor;

		*p++ = ( remainder < 10 ) ? remainder + '0' : remainder + 'a' - 10;
	}
	while ( ud /= divisor );
	/* Terminate BUF.  */
	*p = 0;
	/* Reverse BUF.  */
	p1 = buf;
	p2 = p - 1;

	while ( p1 < p2 )
	{
		char tmp = *p1;

		*p1 = *p2;
		*p2 = tmp;

		p1++;
		p2--;
	}
}
#endif

VOID CalculateMAC( BYTE * pData, UINT nLen, BYTE * pData1, BYTE * pData2 )
{
	UINT i = 0;

	for ( i = 0; i < nLen; i++ )
		pData[i] = pData1[i] ^ pData2[i];
}

