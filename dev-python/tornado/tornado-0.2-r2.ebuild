# Copyright 2010 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit distutils eutils

DESCRIPTION="a scalable, non-blocking web server and tools (as used at FriendFeed)"
HOMEPAGE="http://www.tornadoweb.org/"
SRC_URI="http://www.tornadoweb.org/static/${P}.tar.gz
	http://binhost.ossdl.de/distfiles/tornado-0.2-to-24c9ee9d.patch.lzma"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86 arm ~ppc ~hpa ~sparc"
IUSE="+mark_extras"

DEPEND=">=dev-lang/python-2.5"
RDEPEND="${DEPEND}
	dev-python/simplejson
	>=dev-python/pycurl-7.19.0
	mark_extras? ( dev-python/murmur )
	!!www-servers/tornado"
DEPEND="${DEPEND}
	|| ( app-arch/xz-utils app-arch/lzma-utils )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch ../tornado-0.2-to-24c9ee9d.patch
	if use mark_extras ; then
		epatch "${FILESDIR}"/tornado-0.2-murmurhash.patch
	fi
	sed -e "s:0.2:${PV}:g" "${FILESDIR}"/tornado-0.2-versionstring.patch > "${WORKDIR}"/tornado-versionstring.patch
	epatch "${WORKDIR}"/tornado-versionstring.patch
}
