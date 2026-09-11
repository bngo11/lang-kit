# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson

DESCRIPTION="The Oil Runtime Compiler, a just-in-time compiler for array operations"
HOMEPAGE="https://gstreamer.freedesktop.org/"
SRC_URI="https://gstreamer.freedesktop.org/src/orc/orc-0.4.44.tar.xz -> orc-0.4.44.tar.xz"

LICENSE="BSD BSD-2"
SLOT="0"
KEYWORDS="*"
IUSE="examples pax_kernel"

RDEPEND=""
DEPEND="${RDEPEND}
	app-arch/xz-utils
	>=dev-util/gtk-doc-am-1.12
"

DOCS=( README RELEASE )

src_configure() {
	# any optimisation on PPC/Darwin yields in a complaint from the assembler
	# Parameter error: r0 not allowed for parameter %lu (code as 0 not r0)
	# the same for Intel/Darwin, although the error message there is different
	# but along the same lines
	[[ ${CHOST} == *-darwin* ]] && filter-flags -O*

	local emesonargs=(
		-Dhotdoc=disabled
		-Dorc-target='all'
		$(meson_feature examples)
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	if use pax_kernel; then
		pax-mark m "${ED}"usr/bin/orc-bugreport
		pax-mark m "${ED}"usr/bin/orcc
		pax-mark m "${ED}"usr/$(get_libdir)/liborc*.so*
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/{*.c,*.orc}
	fi
}

pkg_postinst() {
	if use pax_kernel; then
		ewarn "Please run \"revdep-pax\" after installation".
		ewarn "It's provided by sys-apps/elfix."
	fi
}