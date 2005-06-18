dnl $XdotOrg: $
dnl
dnl Copyright 2005 Sun Microsystems, Inc.  All rights reserved.
dnl 
dnl Permission to use, copy, modify, distribute, and sell this software and its
dnl documentation for any purpose is hereby granted without fee, provided that
dnl the above copyright notice appear in all copies and that both that
dnl copyright notice and this permission notice appear in supporting
dnl documentation.
dnl 
dnl The above copyright notice and this permission notice shall be included
dnl in all copies or substantial portions of the Software.
dnl 
dnl THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
dnl OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
dnl MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
dnl IN NO EVENT SHALL THE OPEN GROUP BE LIABLE FOR ANY CLAIM, DAMAGES OR
dnl OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
dnl ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
dnl OTHER DEALINGS IN THE SOFTWARE.
dnl 
dnl Except as contained in this notice, the name of the copyright holders shall
dnl not be used in advertising or otherwise to promote the sale, use or
dnl other dealings in this Software without prior written authorization
dnl from the copyright holders.
dnl 

# XTRANS_CONNECTION_FLAGS()
# -------------------------
# Standard checks for Xtrans transport flags used by the Xorg packages
# that use Xtrans functions
AC_DEFUN([XTRANS_CONNECTION_FLAGS],
[AC_ARG_ENABLE(unix-transport,[  --disable-unix-transport ], 
	[UNIXCONN=$enableval], [UNIXCONN=yes])
 AC_ARG_ENABLE(tcp-transport, [  --disable-tcp-transport ], 
	[TCPCONN=$enableval], [TCPCONN=yes])
 if test "$UNIXCONN" = "yes"; then
	AC_DEFINE(UNIXCONN,1,[Support UNIX socket connections])
 fi
 if test "$TCPCONN" = "yes"; then
	AC_DEFINE(TCPCONN,1,[Support TCP socket connections])
	# SVR4 hides these in libraries other than libc
	AC_SEARCH_LIBS(socket, [socket])
	AC_SEARCH_LIBS(gethostbyname, [nsl])
 fi
 # Needs to come after above checks for libsocket & libnsl for SVR4 systems
 AC_ARG_ENABLE(ipv6,          [  --disable-ipv6 ], [IPV6CONN=$enableval], 
	[AC_CHECK_FUNC(getaddrinfo,[IPV6CONN=yes],[IPV6CONN=no])])
 if test "$IPV6CONN" = "yes"; then
	AC_DEFINE(IPv6,1,[Support IPv6 for TCP connections])
 fi
]) # XTRANS_CONNECTION_FLAGS


# XTRANS_SECURE_RPC_FLAGS()
# -------------------------
# Check for Secure RPC functions - must come after XTRANS_CONNECTION_FLAGS
# so that any necessary networking libraries are already found
AC_DEFUN([XTRANS_SECURE_RPC_FLAGS],
[AC_REQUIRE([XTRANS_CONNECTION_FLAGS])
 AC_ARG_ENABLE(secure-rpc, 
	AC_HELP_STRING([--enable-secure-rpc],[Enable Secure RPC]),
        [SECURE_RPC=$enableval], [SECURE_RPC="try"])

 if test "x$SECURE_RPC" == "xyes" -o "x$SECURE_RPC" == "xtry" ; then
	FOUND_SECURE_RPC="no"
	AC_CHECK_FUNCS([authdes_seccreate authdes_create],
			[FOUND_SECURE_RPC="yes"])
	if test "x$FOUND_SECURE_RPC" == "xno" ; then
		if test "x$SECURE_RPC" == "xyes" ; then
	AC_MSG_ERROR([Secure RPC requested, but required functions not found])
		fi	
		SECURE_RPC="no"
	else
		SECURE_RPC="yes"
	fi
 fi
 AC_MSG_CHECKING([if Secure RPC authentication ("SUN-DES-1") should be supported for X11 clients])
 if test "x$SECURE_RPC" == "xyes" ; then
	AC_DEFINE(SECURE_RPC, 1, [Support Secure RPC ("SUN-DES-1") authentication for X11 clients])
 fi
 AC_MSG_RESULT($SECURE_RPC)
]) # XTRANS_SECURE_RPC_FLAGS

