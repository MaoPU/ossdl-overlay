# Copyright 2008-2010 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

PYTHON_DEPEND="2:2.4"

inherit distutils eutils

MY_PN="huBarcode"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="generation of barcodes in Python"
HOMEPAGE="https://cybernetics.hudora.biz/projects/wiki/huBarcode"
SRC_URI="http://cybernetics.hudora.biz/dist/${MY_PN}/${MY_P}.tar.gz"
RESTRICT="nomirror"

LICENSE="BSD"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE=""
SLOT="0"

RDEPEND="dev-python/imaging"
DEPEND="${RDEPEND}
	dev-python/setuptools"

PYTHON_MODNAME=$MY_PN
S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/hubarcode-0.52-datamatrix-PIL.patch"
}

src_install() {
        distutils_src_install
        cp -r "${S}/qrcode/qrcode_data" "${D}$(python_get_sitedir)/qrcode/" || die "qrcode_date couldn't be copied"
}

pkg_postinst() {
        python_mod_optimize $(python_get_sitedir)/qrcode
}