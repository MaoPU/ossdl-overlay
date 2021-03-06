# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit qt3 eutils

DESCRIPTION="F4L is an open source development environment for Macromedia Flash"
HOMEPAGE="http://f4l.sourceforge.net/"
SRC_URI="mirror://sourceforge/f4l/f4l-${PV}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* -x86 -amd64"

IUSE=""

RDEPEND="=x11-libs/qt-3*"
DEPEND="${RDEPEND}"

S=${WORKDIR}/f4l-${PV}

src_compile() {
	addpredict "${QTDIR}/etc/settings"
	local myconf=

	cd ${S}
	qmake
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die
	insinto /usr/share/pixmaps/${PN}/
	doins f4lm/main_ico1.xpm 
	make_desktop_entry f4lm "Flash for Linux" ${PN}/main_ico1.xpm Development
}
