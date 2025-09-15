# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Superset of JavaScript with optional static typing, classes and interfaces"
HOMEPAGE="https://www.typescriptlang.org/
	https://github.com/microsoft/TypeScript/"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"
S="${WORKDIR}/package"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	net-libs/nodejs
"
BDEPEND="
	>=net-libs/nodejs-16
"

src_compile() {
	# Skip, nothing to compile here.
	:
}

src_install() {
	local -a myopts=(
		--audit false
		--color false
		--foreground-scripts
		--global
		--offline
		--omit dev
		--prefix "${ED}/usr"
		--progress false
		--verbose
	)
	npm "${myopts[@]}" install "${DISTDIR}/${P}.tgz" || die "npm install failed"

	dodoc *.md *.txt
}
