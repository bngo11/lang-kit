# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A Nim library to parse TOML files"
HOMEPAGE="https://github.com/NimParsers/parsetoml"
SRC_URI="https://github.com/NimParsers/parsetoml/archive/609e03e0a7d69d25330786f2cac034c8dd265ed5.tar.gz -> parsetoml-20220405.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND=">=dev-lang/nim-0.18.0"

RDEPEND="${DEPEND}"

src_unpack() {
	unpack "${A}"
	mv "${WORKDIR}"/parsetoml-* "${S}" || die
}

src_prepare() {
	default
	rm -rf .gitignore LICENSE .github
}

src_install() {
	insinto /opt/nimble/pkgs/${P}
	doins -r *
	dodir /opt/nimble/pkgs/${P}
	dosym ./src/parsetoml.nim /opt/nimble/pkgs/${P}/parsetoml.nim
}