# Copyright 2009-2010 W-Mark Kubacki
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic

MY_PN="MonetDB-client"
MY_P=${MY_PN}-${PV}

DESCRIPTION="libraries and programs to communicate with the server(s) that are part of the MonetDB/SQL suite"
HOMEPAGE="http://monetdb.cwi.nl/"
SRC_URI="http://monetdb.cwi.nl/downloads/sources/Nov2009-SP2/${MY_P}.tar.lzma"
RESTRICT="nomirror"

LICENSE="MonetDBPL-1.1"
SLOT="5"
KEYWORDS="amd64 x86 arm"
IUSE="debug python perl php ruby curl iconv bzip2 zlib coroutines odbc"

RDEPEND=">=dev-libs/libpcre-4.5
	>=dev-libs/openssl-0.9.8
	sys-libs/readline
	python? ( >=dev-lang/python-2.4 )
	perl? ( dev-lang/perl )
	php? ( dev-lang/php )
	ruby? ( dev-lang/ruby )
	curl? ( net-misc/curl )
	iconv? ( virtual/libiconv )
	bzip2? ( || ( app-arch/bzip2 app-arch/pbzip2 ) )
	zlib? ( sys-libs/zlib )
	coroutines? ( dev-libs/pcl )
	odbc? ( dev-db/unixODBC )
	>=dev-db/monetdb-common-1.34.0
	!!dev-db/monetdb"
DEPEND="|| ( app-arch/xz-utils app-arch/lzma-utils )
	${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_compile() {
	local myconf=
	if use debug; then
		myconf+=" --enable-strict --disable-optimize --enable-debug --enable-assert"
	else
		myconf+=" --disable-strict --disable-debug --disable-assert"
		if ! hasq "-O6" ${CFLAGS}; then
			myconf+=" --enable-optimize"
			filter-flags "-Os" "-O" "-O[012345]"
		fi
	fi
	# Deal with auto-dependencies
	use python 	&& myconf+=" $(use_with python)"
	use perl	&& myconf+=" $(use_with perl)"
	use php		&& myconf+=" $(use_with php)"
	use ruby	&& myconf+=" $(use_with ruby)"
	use curl	&& myconf+=" $(use_with curl)"
	use iconv	&& myconf+=" $(use_with iconv)"
	use bzip2	&& myconf+=" $(use_with bzip2 bz2)"
	use zlib	&& myconf+=" $(use_with zlib z)"
	use coroutines	&& myconf+=" $(use_with coroutines pcl)"
	use odbc	&& myconf+=" $(use_with odbc unixodbc)"

	econf ${myconf} || die "econf"
	emake || die "emake"
}

src_install() {
	emake DESTDIR="${D}" install || die "install"

	# prevent binaries from being installed in wrong paths (FHS 2.3)
	rm "${D}"/usr/bin/monetdb-clients-config
	dosbin conf/monetdb-clients-config

	# remove testing framework and compiled tests
	rm -rf "${D}"/usr/lib/MonetDB/Tests "${D}"/usr/lib64/MonetDB/Tests || true

	# remove windows cruft
	find "${D}" -name "*.bat" -exec rm "{}" \; || die "removing windows stuff"

	# remove unwanted parts
	use php		|| rm -rf "${D}"/usr/share/php || true
	use perl	|| rm -rf "${D}"/usr/share/MonetDB/perl "${D}"/usr/lib/perl "${D}"/usr/lib64/perl5 || true
	use python	|| rm -rf "${D}"/usr/lib64/python2.6 || true
	use odbc	|| \
	rm -rf "${D}"/usr/lib/libMonetODBC* "${D}"/usr/lib64/libMonetODBC* "${D}"/usr/include/MonetDB/odbc/ || true
}